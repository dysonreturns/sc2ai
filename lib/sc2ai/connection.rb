# frozen_string_literal: true

require "async"
require "async/io/stream"
require "async/http/endpoint"
require "async/websocket"
require_relative "connection/requests"

module Sc2
  # Manages client connection to the Api
  class Connection
    # Api requests
    include Sc2::Connection::Requests

    attr_accessor :host, :port, :websocket

    # Last known game status, i.e. :launched, :ended, :unknown
    #   :launched // Game has been launch and is not yet doing anything.
    #   :init_game // Create game has been called, and the host is awaiting players.
    #   :in_game // In a single or multiplayer game.
    #   :in_replay // In a replay.
    #   :ended // Game has ended, can still request game info, but ready for a new game.
    #   :quit // Application is shutting down.
    #   :unknown // Should not happen, but indicates an error if it occurs.
    #   @return [Symbol] game status
    attr_reader :status

    # @!attribute listeners
    #   @return [Hash<String,Array>] of callbacks
    attr_reader :listeners

    # @param host [String]
    # @param port [Integer]
    # #param [Sc2::CallbackListener] listener
    def initialize(host:, port:)
      @host = host
      @port = port
      @listeners = {}
      @websocket = nil
      @status = :unknown
      # Only allow one request at a time.
      # TODO: Since it turns out the client websocket can only handle 1 request at a time, we don't stricly need Async
      @scheduler = Async::Semaphore.new(1)
    end

    # Attempts to connect for a period of time, ignoring errors nad performing on_* callbacks
    # @return [void]
    def connect
      attempt = 1
      Sc2.logger.debug { "Waiting for client..." } if (attempt % 5).zero?

      begin
        @websocket = Async::WebSocket::Client.connect(endpoint) # , handler: Sc2::Connection::Connection)
        @listeners[ConnectionListener.name]&.each { _1.on_connected(self) }
        # do initial ping to ensure status is set and connection is working
        response_ping = ping
        Sc2.logger.debug { "Game version: #{response_ping.game_version}" }
      rescue Errno::ECONNREFUSED
        raise Error, "Connection timeout. Max retry exceeded." unless (attempt += 1) < 30 # 30s attempts

        @listeners[ConnectionListener.name]&.each { _1.on_connection_waiting(self) }
        sleep(1)
        retry
      rescue Error => e
        Sc2.logger.error "#{e.class}: #{e.message}"
        @listeners[ConnectionListener.name]&.each { _1.on_disconnect(self) }
      end
      nil
    end

    # Closes Connection to client
    # @return [void]
    def close
      @websocket&.close
      @listeners[ConnectionListener.name]&.each { _1.on_disconnect(self) }
    end

    # Add a listener of specific callback type
    # @param listener [Object]
    # @param klass [Module<Sc2::Connection::ConnectionListener>,Module<Sc2::Connection::StatusListener>]
    def add_listener(listener, klass:)
      @listeners[klass.to_s] ||= []
      @listeners[klass.to_s].push(listener)
    end

    # Removes a listener of specific callback type
    # @param listener [Object]
    # @param klass [Module<Sc2::Connection::ConnectionListener>,Module<Sc2::Connection::StatusListener>]
    def remove_listener(listener, klass:)
      @listeners[klass.to_s].delete(listener)
    end

    # ---------------------------------------------------------
    # Sends a request synchronously and returns Api::Response type
    # @return [Api::Response] response
    def send_request(request)
      @scheduler.async do |_task|
        # r = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC) #debug
        # name =  request.is_a?(String) ? request : request.request #debug
        request = request.to_proto unless request.is_a?(String)
        @websocket.send_binary(request)
        response = Api::Response.decode(@websocket.read.to_str)

        if @status != response.status
          @status = response.status
          @listeners[StatusListener.name]&.each { _1.on_status_change(@status) }
        end

        # Sc2.logger.debug { response }
        # puts "#{(::Process.clock_gettime(::Process::CLOCK_MONOTONIC) - r) * 1000} - #{name}" #debug
        response
      end.wait
    rescue EOFError => e
      Sc2.logger.error e
      close
    end

    # Sends and ignores response.
    # Meant to be used as optimization for RequestStep.
    # No other command sends and ignores.
    # Expects request to be to_proto'd already
    # @return [void]
    def send_request_and_ignore(request)
      @scheduler.async do |_task|
        @websocket.send_binary(request)
        while @websocket.read_frame
          if @websocket.frames.last&.finished?
            @websocket.frames = []
            break
          end
        end
      end.wait

      nil
    end

    private

    attr_writer :status, :listeners

    # @return [HTTP::Endpoint] websocket url for establishing protobuf connection
    def endpoint
      Async::HTTP::Endpoint.parse("ws://#{@host}:#{@port}/sc2api")
    end
  end
end
