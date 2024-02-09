module Api
  module TechTree
    class << self
      private

      def unit_type_creation_abilities_data = {Api::UnitTypeId::COMMANDCENTER =>
  {Api::UnitTypeId::SCV =>
    {ability: Api::AbilityId::COMMANDCENTERTRAIN_SCV},
   Api::UnitTypeId::PLANETARYFORTRESS =>
    {ability: Api::AbilityId::UPGRADETOPLANETARYFORTRESS_PLANETARYFORTRESS,
     required_building: Api::UnitTypeId::ENGINEERINGBAY},
   Api::UnitTypeId::ORBITALCOMMAND =>
    {ability: Api::AbilityId::UPGRADETOORBITAL_ORBITALCOMMAND,
     required_building: Api::UnitTypeId::BARRACKS}},
                                               Api::UnitTypeId::BARRACKS =>
  {Api::UnitTypeId::MARINE =>
    {ability: Api::AbilityId::BARRACKSTRAIN_MARINE},
   Api::UnitTypeId::REAPER =>
    {ability: Api::AbilityId::BARRACKSTRAIN_REAPER},
   Api::UnitTypeId::GHOST =>
    {ability: Api::AbilityId::BARRACKSTRAIN_GHOST,
     requires_techlab: true,
     required_building: Api::UnitTypeId::GHOSTACADEMY},
   Api::UnitTypeId::MARAUDER =>
    {ability: Api::AbilityId::BARRACKSTRAIN_MARAUDER,
     requires_techlab: true}},
                                               Api::UnitTypeId::FACTORY =>
  {Api::UnitTypeId::HELLION =>
    {ability: Api::AbilityId::FACTORYTRAIN_HELLION},
   Api::UnitTypeId::CYCLONE => {ability: Api::AbilityId::TRAIN_CYCLONE},
   Api::UnitTypeId::WIDOWMINE =>
    {ability: Api::AbilityId::FACTORYTRAIN_WIDOWMINE},
   Api::UnitTypeId::SIEGETANK =>
    {ability: Api::AbilityId::FACTORYTRAIN_SIEGETANK,
     requires_techlab: true},
   Api::UnitTypeId::THOR =>
    {ability: Api::AbilityId::FACTORYTRAIN_THOR,
     requires_techlab: true,
     required_building: Api::UnitTypeId::ARMORY},
   Api::UnitTypeId::HELLIONTANK =>
    {ability: Api::AbilityId::TRAIN_HELLBAT,
     required_building: Api::UnitTypeId::ARMORY}},
                                               Api::UnitTypeId::STARPORT =>
  {Api::UnitTypeId::MEDIVAC =>
    {ability: Api::AbilityId::STARPORTTRAIN_MEDIVAC},
   Api::UnitTypeId::VIKINGFIGHTER =>
    {ability: Api::AbilityId::STARPORTTRAIN_VIKINGFIGHTER},
   Api::UnitTypeId::LIBERATOR =>
    {ability: Api::AbilityId::STARPORTTRAIN_LIBERATOR},
   Api::UnitTypeId::BANSHEE =>
    {ability: Api::AbilityId::STARPORTTRAIN_BANSHEE,
     requires_techlab: true},
   Api::UnitTypeId::RAVEN =>
    {ability: Api::AbilityId::STARPORTTRAIN_RAVEN, requires_techlab: true},
   Api::UnitTypeId::BATTLECRUISER =>
    {ability: Api::AbilityId::STARPORTTRAIN_BATTLECRUISER,
     requires_techlab: true,
     required_building: Api::UnitTypeId::FUSIONCORE}},
                                               Api::UnitTypeId::SCV =>
  {Api::UnitTypeId::COMMANDCENTER =>
    {ability: Api::AbilityId::TERRANBUILD_COMMANDCENTER,
     requires_placement_position: true},
   Api::UnitTypeId::SUPPLYDEPOT =>
    {ability: Api::AbilityId::TERRANBUILD_SUPPLYDEPOT,
     requires_placement_position: true},
   Api::UnitTypeId::REFINERY =>
    {ability: Api::AbilityId::TERRANBUILD_REFINERY},
   Api::UnitTypeId::BARRACKS =>
    {ability: Api::AbilityId::TERRANBUILD_BARRACKS,
     required_building: Api::UnitTypeId::SUPPLYDEPOT,
     requires_placement_position: true},
   Api::UnitTypeId::ENGINEERINGBAY =>
    {ability: Api::AbilityId::TERRANBUILD_ENGINEERINGBAY,
     required_building: Api::UnitTypeId::COMMANDCENTER,
     requires_placement_position: true},
   Api::UnitTypeId::MISSILETURRET =>
    {ability: Api::AbilityId::TERRANBUILD_MISSILETURRET,
     required_building: Api::UnitTypeId::ENGINEERINGBAY,
     requires_placement_position: true},
   Api::UnitTypeId::BUNKER =>
    {ability: Api::AbilityId::TERRANBUILD_BUNKER,
     required_building: Api::UnitTypeId::BARRACKS,
     requires_placement_position: true},
   Api::UnitTypeId::SENSORTOWER =>
    {ability: Api::AbilityId::TERRANBUILD_SENSORTOWER,
     required_building: Api::UnitTypeId::ENGINEERINGBAY,
     requires_placement_position: true},
   Api::UnitTypeId::GHOSTACADEMY =>
    {ability: Api::AbilityId::TERRANBUILD_GHOSTACADEMY,
     required_building: Api::UnitTypeId::BARRACKS,
     requires_placement_position: true},
   Api::UnitTypeId::FACTORY =>
    {ability: Api::AbilityId::TERRANBUILD_FACTORY,
     required_building: Api::UnitTypeId::BARRACKS,
     requires_placement_position: true},
   Api::UnitTypeId::STARPORT =>
    {ability: Api::AbilityId::TERRANBUILD_STARPORT,
     required_building: Api::UnitTypeId::FACTORY,
     requires_placement_position: true},
   Api::UnitTypeId::ARMORY =>
    {ability: Api::AbilityId::TERRANBUILD_ARMORY,
     required_building: Api::UnitTypeId::FACTORY,
     requires_placement_position: true},
   Api::UnitTypeId::FUSIONCORE =>
    {ability: Api::AbilityId::TERRANBUILD_FUSIONCORE,
     required_building: Api::UnitTypeId::STARPORT,
     requires_placement_position: true}},
                                               Api::UnitTypeId::RAVEN =>
  {Api::UnitTypeId::AUTOTURRET =>
    {ability: Api::AbilityId::BUILDAUTOTURRET_AUTOTURRET}},
                                               Api::UnitTypeId::NEXUS =>
  {Api::UnitTypeId::PROBE => {ability: Api::AbilityId::NEXUSTRAIN_PROBE},
   Api::UnitTypeId::MOTHERSHIP =>
    {ability: Api::AbilityId::NEXUSTRAINMOTHERSHIP_MOTHERSHIP,
     required_building: Api::UnitTypeId::FLEETBEACON}},
                                               Api::UnitTypeId::GATEWAY =>
  {Api::UnitTypeId::ZEALOT =>
    {ability: Api::AbilityId::GATEWAYTRAIN_ZEALOT, requires_power: true},
   Api::UnitTypeId::STALKER =>
    {ability: Api::AbilityId::GATEWAYTRAIN_STALKER,
     required_building: Api::UnitTypeId::CYBERNETICSCORE,
     requires_power: true},
   Api::UnitTypeId::HIGHTEMPLAR =>
    {ability: Api::AbilityId::GATEWAYTRAIN_HIGHTEMPLAR,
     required_building: Api::UnitTypeId::TEMPLARARCHIVE,
     requires_power: true},
   Api::UnitTypeId::DARKTEMPLAR =>
    {ability: Api::AbilityId::GATEWAYTRAIN_DARKTEMPLAR,
     required_building: Api::UnitTypeId::DARKSHRINE,
     requires_power: true},
   Api::UnitTypeId::SENTRY =>
    {ability: Api::AbilityId::GATEWAYTRAIN_SENTRY,
     required_building: Api::UnitTypeId::CYBERNETICSCORE,
     requires_power: true},
   Api::UnitTypeId::ADEPT =>
    {ability: Api::AbilityId::TRAIN_ADEPT,
     required_building: Api::UnitTypeId::CYBERNETICSCORE,
     requires_power: true}},
                                               Api::UnitTypeId::STARGATE =>
  {Api::UnitTypeId::PHOENIX =>
    {ability: Api::AbilityId::STARGATETRAIN_PHOENIX, requires_power: true},
   Api::UnitTypeId::VOIDRAY =>
    {ability: Api::AbilityId::STARGATETRAIN_VOIDRAY, requires_power: true},
   Api::UnitTypeId::ORACLE =>
    {ability: Api::AbilityId::STARGATETRAIN_ORACLE, requires_power: true},
   Api::UnitTypeId::CARRIER =>
    {ability: Api::AbilityId::STARGATETRAIN_CARRIER,
     required_building: Api::UnitTypeId::FLEETBEACON,
     requires_power: true},
   Api::UnitTypeId::TEMPEST =>
    {ability: Api::AbilityId::STARGATETRAIN_TEMPEST,
     required_building: Api::UnitTypeId::FLEETBEACON,
     requires_power: true}},
                                               Api::UnitTypeId::ROBOTICSFACILITY =>
  {Api::UnitTypeId::WARPPRISM =>
    {ability: Api::AbilityId::ROBOTICSFACILITYTRAIN_WARPPRISM,
     requires_power: true},
   Api::UnitTypeId::OBSERVER =>
    {ability: Api::AbilityId::ROBOTICSFACILITYTRAIN_OBSERVER,
     requires_power: true},
   Api::UnitTypeId::IMMORTAL =>
    {ability: Api::AbilityId::ROBOTICSFACILITYTRAIN_IMMORTAL,
     requires_power: true},
   Api::UnitTypeId::COLOSSUS =>
    {ability: Api::AbilityId::ROBOTICSFACILITYTRAIN_COLOSSUS,
     required_building: Api::UnitTypeId::ROBOTICSBAY,
     requires_power: true},
   Api::UnitTypeId::DISRUPTOR =>
    {ability: Api::AbilityId::TRAIN_DISRUPTOR,
     required_building: Api::UnitTypeId::ROBOTICSBAY,
     requires_power: true}},
                                               Api::UnitTypeId::PROBE =>
  {Api::UnitTypeId::NEXUS =>
    {ability: Api::AbilityId::PROTOSSBUILD_NEXUS,
     requires_placement_position: true},
   Api::UnitTypeId::PYLON =>
    {ability: Api::AbilityId::PROTOSSBUILD_PYLON,
     requires_placement_position: true},
   Api::UnitTypeId::ASSIMILATOR =>
    {ability: Api::AbilityId::PROTOSSBUILD_ASSIMILATOR},
   Api::UnitTypeId::GATEWAY =>
    {ability: Api::AbilityId::PROTOSSBUILD_GATEWAY,
     required_building: Api::UnitTypeId::PYLON,
     requires_placement_position: true},
   Api::UnitTypeId::FORGE =>
    {ability: Api::AbilityId::PROTOSSBUILD_FORGE,
     required_building: Api::UnitTypeId::PYLON,
     requires_placement_position: true},
   Api::UnitTypeId::FLEETBEACON =>
    {ability: Api::AbilityId::PROTOSSBUILD_FLEETBEACON,
     required_building: Api::UnitTypeId::STARGATE,
     requires_placement_position: true},
   Api::UnitTypeId::TWILIGHTCOUNCIL =>
    {ability: Api::AbilityId::PROTOSSBUILD_TWILIGHTCOUNCIL,
     required_building: Api::UnitTypeId::CYBERNETICSCORE,
     requires_placement_position: true},
   Api::UnitTypeId::PHOTONCANNON =>
    {ability: Api::AbilityId::PROTOSSBUILD_PHOTONCANNON,
     required_building: Api::UnitTypeId::FORGE,
     requires_placement_position: true},
   Api::UnitTypeId::STARGATE =>
    {ability: Api::AbilityId::PROTOSSBUILD_STARGATE,
     required_building: Api::UnitTypeId::CYBERNETICSCORE,
     requires_placement_position: true},
   Api::UnitTypeId::TEMPLARARCHIVE =>
    {ability: Api::AbilityId::PROTOSSBUILD_TEMPLARARCHIVE,
     required_building: Api::UnitTypeId::TWILIGHTCOUNCIL,
     requires_placement_position: true},
   Api::UnitTypeId::DARKSHRINE =>
    {ability: Api::AbilityId::PROTOSSBUILD_DARKSHRINE,
     required_building: Api::UnitTypeId::TWILIGHTCOUNCIL,
     requires_placement_position: true},
   Api::UnitTypeId::ROBOTICSBAY =>
    {ability: Api::AbilityId::PROTOSSBUILD_ROBOTICSBAY,
     required_building: Api::UnitTypeId::ROBOTICSFACILITY,
     requires_placement_position: true},
   Api::UnitTypeId::ROBOTICSFACILITY =>
    {ability: Api::AbilityId::PROTOSSBUILD_ROBOTICSFACILITY,
     required_building: Api::UnitTypeId::CYBERNETICSCORE,
     requires_placement_position: true},
   Api::UnitTypeId::CYBERNETICSCORE =>
    {ability: Api::AbilityId::PROTOSSBUILD_CYBERNETICSCORE,
     required_building: Api::UnitTypeId::GATEWAY,
     requires_placement_position: true},
   Api::UnitTypeId::SHIELDBATTERY =>
    {ability: Api::AbilityId::BUILD_SHIELDBATTERY,
     required_building: Api::UnitTypeId::CYBERNETICSCORE,
     requires_placement_position: true}},
                                               Api::UnitTypeId::HATCHERY =>
  {Api::UnitTypeId::LAIR =>
    {ability: Api::AbilityId::UPGRADETOLAIR_LAIR,
     required_building: Api::UnitTypeId::SPAWNINGPOOL},
   Api::UnitTypeId::QUEEN =>
    {ability: Api::AbilityId::TRAINQUEEN_QUEEN,
     required_building: Api::UnitTypeId::SPAWNINGPOOL}},
                                               Api::UnitTypeId::SPIRE =>
  {Api::UnitTypeId::GREATERSPIRE =>
    {ability: Api::AbilityId::UPGRADETOGREATERSPIRE_GREATERSPIRE,
     required_building: Api::UnitTypeId::HIVE}},
                                               Api::UnitTypeId::NYDUSNETWORK =>
  {Api::UnitTypeId::NYDUSCANAL =>
    {ability: Api::AbilityId::BUILD_NYDUSWORM,
     requires_placement_position: true}},
                                               Api::UnitTypeId::LAIR =>
  {Api::UnitTypeId::HIVE =>
    {ability: Api::AbilityId::UPGRADETOHIVE_HIVE,
     required_building: Api::UnitTypeId::INFESTATIONPIT},
   Api::UnitTypeId::QUEEN =>
    {ability: Api::AbilityId::TRAINQUEEN_QUEEN,
     required_building: Api::UnitTypeId::SPAWNINGPOOL}},
                                               Api::UnitTypeId::HIVE =>
  {Api::UnitTypeId::QUEEN =>
    {ability: Api::AbilityId::TRAINQUEEN_QUEEN,
     required_building: Api::UnitTypeId::SPAWNINGPOOL}},
                                               Api::UnitTypeId::DRONE =>
  {Api::UnitTypeId::HATCHERY =>
    {ability: Api::AbilityId::ZERGBUILD_HATCHERY,
     requires_placement_position: true},
   Api::UnitTypeId::EXTRACTOR =>
    {ability: Api::AbilityId::ZERGBUILD_EXTRACTOR},
   Api::UnitTypeId::SPAWNINGPOOL =>
    {ability: Api::AbilityId::ZERGBUILD_SPAWNINGPOOL,
     required_building: Api::UnitTypeId::HATCHERY,
     requires_placement_position: true},
   Api::UnitTypeId::EVOLUTIONCHAMBER =>
    {ability: Api::AbilityId::ZERGBUILD_EVOLUTIONCHAMBER,
     required_building: Api::UnitTypeId::HATCHERY,
     requires_placement_position: true},
   Api::UnitTypeId::HYDRALISKDEN =>
    {ability: Api::AbilityId::ZERGBUILD_HYDRALISKDEN,
     required_building: Api::UnitTypeId::LAIR,
     requires_placement_position: true},
   Api::UnitTypeId::SPIRE =>
    {ability: Api::AbilityId::ZERGBUILD_SPIRE,
     required_building: Api::UnitTypeId::LAIR,
     requires_placement_position: true},
   Api::UnitTypeId::ULTRALISKCAVERN =>
    {ability: Api::AbilityId::ZERGBUILD_ULTRALISKCAVERN,
     required_building: Api::UnitTypeId::HIVE,
     requires_placement_position: true},
   Api::UnitTypeId::INFESTATIONPIT =>
    {ability: Api::AbilityId::ZERGBUILD_INFESTATIONPIT,
     required_building: Api::UnitTypeId::LAIR,
     requires_placement_position: true},
   Api::UnitTypeId::NYDUSNETWORK =>
    {ability: Api::AbilityId::ZERGBUILD_NYDUSNETWORK,
     required_building: Api::UnitTypeId::LAIR,
     requires_placement_position: true},
   Api::UnitTypeId::BANELINGNEST =>
    {ability: Api::AbilityId::ZERGBUILD_BANELINGNEST,
     required_building: Api::UnitTypeId::SPAWNINGPOOL,
     requires_placement_position: true},
   Api::UnitTypeId::LURKERDENMP =>
    {ability: Api::AbilityId::BUILD_LURKERDEN,
     required_building: Api::UnitTypeId::HYDRALISKDEN,
     requires_placement_position: true},
   Api::UnitTypeId::ROACHWARREN =>
    {ability: Api::AbilityId::ZERGBUILD_ROACHWARREN,
     required_building: Api::UnitTypeId::SPAWNINGPOOL,
     requires_placement_position: true},
   Api::UnitTypeId::SPINECRAWLER =>
    {ability: Api::AbilityId::ZERGBUILD_SPINECRAWLER,
     required_building: Api::UnitTypeId::SPAWNINGPOOL,
     requires_placement_position: true},
   Api::UnitTypeId::SPORECRAWLER =>
    {ability: Api::AbilityId::ZERGBUILD_SPORECRAWLER,
     required_building: Api::UnitTypeId::SPAWNINGPOOL,
     requires_placement_position: true}},
                                               Api::UnitTypeId::OVERLORD =>
  {Api::UnitTypeId::OVERSEER =>
    {ability: Api::AbilityId::MORPH_OVERSEER,
     required_building: Api::UnitTypeId::LAIR},
   Api::UnitTypeId::OVERLORDTRANSPORT =>
    {ability: Api::AbilityId::MORPH_OVERLORDTRANSPORT,
     required_building: Api::UnitTypeId::LAIR}},
                                               Api::UnitTypeId::HYDRALISK =>
  {Api::UnitTypeId::LURKERMP =>
    {ability: Api::AbilityId::MORPH_LURKER,
     required_building: Api::UnitTypeId::LURKERDENMP}},
                                               Api::UnitTypeId::ROACH =>
  {Api::UnitTypeId::RAVAGER =>
    {ability: Api::AbilityId::MORPHTORAVAGER_RAVAGER,
     required_building: Api::UnitTypeId::HATCHERY}},
                                               Api::UnitTypeId::CORRUPTOR =>
  {Api::UnitTypeId::BROODLORD =>
    {ability: Api::AbilityId::MORPHTOBROODLORD_BROODLORD,
     required_building: Api::UnitTypeId::GREATERSPIRE}},
                                               Api::UnitTypeId::QUEEN =>
  {Api::UnitTypeId::CREEPTUMORQUEEN =>
    {ability: Api::AbilityId::BUILD_CREEPTUMOR_QUEEN,
     requires_placement_position: true},
   Api::UnitTypeId::CREEPTUMOR =>
    {ability: Api::AbilityId::BUILD_CREEPTUMOR,
     requires_placement_position: true}},
                                               Api::UnitTypeId::OVERSEER =>
  {Api::UnitTypeId::CHANGELING =>
    {ability: Api::AbilityId::SPAWNCHANGELING_SPAWNCHANGELING}},
                                               Api::UnitTypeId::PLANETARYFORTRESS =>
  {Api::UnitTypeId::SCV =>
    {ability: Api::AbilityId::COMMANDCENTERTRAIN_SCV}},
                                               Api::UnitTypeId::ORBITALCOMMAND =>
  {Api::UnitTypeId::SCV =>
    {ability: Api::AbilityId::COMMANDCENTERTRAIN_SCV}},
                                               Api::UnitTypeId::WARPGATE =>
  {Api::UnitTypeId::ZEALOT =>
    {ability: Api::AbilityId::WARPGATETRAIN_ZEALOT,
     requires_placement_position: true,
     requires_power: true},
   Api::UnitTypeId::STALKER =>
    {ability: Api::AbilityId::WARPGATETRAIN_STALKER,
     required_building: Api::UnitTypeId::CYBERNETICSCORE,
     requires_placement_position: true,
     requires_power: true},
   Api::UnitTypeId::HIGHTEMPLAR =>
    {ability: Api::AbilityId::WARPGATETRAIN_HIGHTEMPLAR,
     required_building: Api::UnitTypeId::TEMPLARARCHIVE,
     requires_placement_position: true,
     requires_power: true},
   Api::UnitTypeId::DARKTEMPLAR =>
    {ability: Api::AbilityId::WARPGATETRAIN_DARKTEMPLAR,
     required_building: Api::UnitTypeId::DARKSHRINE,
     requires_placement_position: true,
     requires_power: true},
   Api::UnitTypeId::SENTRY =>
    {ability: Api::AbilityId::WARPGATETRAIN_SENTRY,
     required_building: Api::UnitTypeId::CYBERNETICSCORE,
     requires_placement_position: true,
     requires_power: true},
   Api::UnitTypeId::ADEPT =>
    {ability: Api::AbilityId::TRAINWARP_ADEPT,
     required_building: Api::UnitTypeId::CYBERNETICSCORE,
     requires_placement_position: true,
     requires_power: true}},
                                               Api::UnitTypeId::CREEPTUMORBURROWED =>
  {Api::UnitTypeId::CREEPTUMOR =>
    {ability: Api::AbilityId::BUILD_CREEPTUMOR,
     requires_placement_position: true}},
                                               Api::UnitTypeId::CREEPTUMORQUEEN =>
  {Api::UnitTypeId::CREEPTUMOR =>
    {ability: Api::AbilityId::BUILD_CREEPTUMOR_TUMOR,
     requires_placement_position: true}},
                                               Api::UnitTypeId::LARVA =>
  {Api::UnitTypeId::DRONE => {ability: Api::AbilityId::LARVATRAIN_DRONE},
   Api::UnitTypeId::OVERLORD =>
    {ability: Api::AbilityId::LARVATRAIN_OVERLORD},
   Api::UnitTypeId::ZERGLING =>
    {ability: Api::AbilityId::LARVATRAIN_ZERGLING,
     required_building: Api::UnitTypeId::SPAWNINGPOOL},
   Api::UnitTypeId::HYDRALISK =>
    {ability: Api::AbilityId::LARVATRAIN_HYDRALISK,
     required_building: Api::UnitTypeId::HYDRALISKDEN},
   Api::UnitTypeId::MUTALISK =>
    {ability: Api::AbilityId::LARVATRAIN_MUTALISK,
     required_building: Api::UnitTypeId::SPIRE},
   Api::UnitTypeId::ULTRALISK =>
    {ability: Api::AbilityId::LARVATRAIN_ULTRALISK,
     required_building: Api::UnitTypeId::ULTRALISKCAVERN},
   Api::UnitTypeId::ROACH =>
    {ability: Api::AbilityId::LARVATRAIN_ROACH,
     required_building: Api::UnitTypeId::ROACHWARREN},
   Api::UnitTypeId::INFESTOR =>
    {ability: Api::AbilityId::LARVATRAIN_INFESTOR,
     required_building: Api::UnitTypeId::INFESTATIONPIT},
   Api::UnitTypeId::CORRUPTOR =>
    {ability: Api::AbilityId::LARVATRAIN_CORRUPTOR,
     required_building: Api::UnitTypeId::SPIRE},
   Api::UnitTypeId::VIPER =>
    {ability: Api::AbilityId::LARVATRAIN_VIPER,
     required_building: Api::UnitTypeId::HIVE},
   Api::UnitTypeId::SWARMHOSTMP =>
    {ability: Api::AbilityId::TRAIN_SWARMHOST,
     required_building: Api::UnitTypeId::INFESTATIONPIT}},
                                               Api::UnitTypeId::SWARMHOSTBURROWEDMP =>
  {Api::UnitTypeId::LOCUSTMPFLYING =>
    {ability: Api::AbilityId::EFFECT_SPAWNLOCUSTS}},
                                               Api::UnitTypeId::SWARMHOSTMP =>
  {Api::UnitTypeId::LOCUSTMPFLYING =>
    {ability: Api::AbilityId::EFFECT_SPAWNLOCUSTS}},
                                               Api::UnitTypeId::ORACLE =>
  {Api::UnitTypeId::ORACLESTASISTRAP =>
    {ability: Api::AbilityId::BUILD_STASISTRAP,
     requires_placement_position: true}},
                                               Api::UnitTypeId::OVERLORDTRANSPORT =>
  {Api::UnitTypeId::OVERSEER =>
    {ability: Api::AbilityId::MORPH_OVERSEER,
     required_building: Api::UnitTypeId::LAIR}},
                                               Api::UnitTypeId::OVERSEERSIEGEMODE =>
  {Api::UnitTypeId::CHANGELING =>
    {ability: Api::AbilityId::SPAWNCHANGELING_SPAWNCHANGELING}}}

      # We want to be able to research an upgrade by doing
      # can_research(UpgradeId, return_idle_structures=True) -> returns list of idle structures that can research it
      # So we need to assign each upgrade id one building type, and its research ability and requirements (e.g. armory for infantry level 2)
      #
      # i.e.
      # upgrade_research_abilities_data = {
      #     UnitTypeId.ENGINEERINGBAY: {
      #         UpgradeId.TERRANINFANTRYWEAPONSLEVEL1:
      #         {
      #             ability: AbilityId.ENGINEERINGBAYRESEARCH_TERRANINFANTRYWEAPONSLEVEL1,
      #             required_building: None,
      #             requires_power: False, # If a pylon nearby is required
      #         },
      #         UpgradeId.TERRANINFANTRYWEAPONSLEVEL2: {
      #             ability: AbilityId.ENGINEERINGBAYRESEARCH_TERRANINFANTRYWEAPONSLEVEL2,
      #             required_building: UnitTypeId.ARMORY,
      #             requires_power: False, # If a pylon nearby is required
      #         },
      #     }
      # }
      def upgrade_research_abilities_data = {Api::UnitTypeId::ENGINEERINGBAY =>
  {Api::UpgradeId::HISECAUTOTRACKING =>
    {ability: Api::AbilityId::RESEARCH_HISECAUTOTRACKING},
   Api::UpgradeId::TERRANBUILDINGARMOR =>
    {ability: Api::AbilityId::RESEARCH_TERRANSTRUCTUREARMORUPGRADE},
   Api::UpgradeId::TERRANINFANTRYWEAPONSLEVEL1 =>
    {ability: Api::AbilityId::ENGINEERINGBAYRESEARCH_TERRANINFANTRYWEAPONSLEVEL1},
   Api::UpgradeId::TERRANINFANTRYARMORSLEVEL1 =>
    {ability: Api::AbilityId::ENGINEERINGBAYRESEARCH_TERRANINFANTRYARMORLEVEL1},
   Api::UpgradeId::TERRANINFANTRYWEAPONSLEVEL2 =>
    {ability: Api::AbilityId::ENGINEERINGBAYRESEARCH_TERRANINFANTRYWEAPONSLEVEL2,
     required_building: Api::UnitTypeId::ARMORY,
     required_upgrade: Api::UpgradeId::TERRANINFANTRYWEAPONSLEVEL1},
   Api::UpgradeId::TERRANINFANTRYWEAPONSLEVEL3 =>
    {ability: Api::AbilityId::ENGINEERINGBAYRESEARCH_TERRANINFANTRYWEAPONSLEVEL3,
     required_building: Api::UnitTypeId::ARMORY,
     required_upgrade: Api::UpgradeId::TERRANINFANTRYWEAPONSLEVEL2},
   Api::UpgradeId::TERRANINFANTRYARMORSLEVEL2 =>
    {ability: Api::AbilityId::ENGINEERINGBAYRESEARCH_TERRANINFANTRYARMORLEVEL2,
     required_building: Api::UnitTypeId::ARMORY,
     required_upgrade: Api::UpgradeId::TERRANINFANTRYARMORSLEVEL1},
   Api::UpgradeId::TERRANINFANTRYARMORSLEVEL3 =>
    {ability: Api::AbilityId::ENGINEERINGBAYRESEARCH_TERRANINFANTRYARMORLEVEL3,
     required_building: Api::UnitTypeId::ARMORY,
     required_upgrade: Api::UpgradeId::TERRANINFANTRYARMORSLEVEL2}},
                                             Api::UnitTypeId::GHOSTACADEMY =>
  {Api::UpgradeId::PERSONALCLOAKING =>
    {ability: Api::AbilityId::RESEARCH_PERSONALCLOAKING}},
                                             Api::UnitTypeId::ARMORY =>
  {Api::UpgradeId::TERRANVEHICLEWEAPONSLEVEL1 =>
    {ability: Api::AbilityId::ARMORYRESEARCH_TERRANVEHICLEWEAPONSLEVEL1},
   Api::UpgradeId::TERRANSHIPWEAPONSLEVEL1 =>
    {ability: Api::AbilityId::ARMORYRESEARCH_TERRANSHIPWEAPONSLEVEL1},
   Api::UpgradeId::TERRANVEHICLEANDSHIPARMORSLEVEL1 =>
    {ability: Api::AbilityId::ARMORYRESEARCH_TERRANVEHICLEANDSHIPPLATINGLEVEL1},
   Api::UpgradeId::TERRANVEHICLEWEAPONSLEVEL2 =>
    {ability: Api::AbilityId::ARMORYRESEARCH_TERRANVEHICLEWEAPONSLEVEL2,
     required_upgrade: Api::UpgradeId::TERRANVEHICLEWEAPONSLEVEL1},
   Api::UpgradeId::TERRANVEHICLEWEAPONSLEVEL3 =>
    {ability: Api::AbilityId::ARMORYRESEARCH_TERRANVEHICLEWEAPONSLEVEL3,
     required_upgrade: Api::UpgradeId::TERRANVEHICLEWEAPONSLEVEL2},
   Api::UpgradeId::TERRANSHIPWEAPONSLEVEL2 =>
    {ability: Api::AbilityId::ARMORYRESEARCH_TERRANSHIPWEAPONSLEVEL2,
     required_upgrade: Api::UpgradeId::TERRANSHIPWEAPONSLEVEL1},
   Api::UpgradeId::TERRANSHIPWEAPONSLEVEL3 =>
    {ability: Api::AbilityId::ARMORYRESEARCH_TERRANSHIPWEAPONSLEVEL3,
     required_upgrade: Api::UpgradeId::TERRANSHIPWEAPONSLEVEL2},
   Api::UpgradeId::TERRANVEHICLEANDSHIPARMORSLEVEL2 =>
    {ability: Api::AbilityId::ARMORYRESEARCH_TERRANVEHICLEANDSHIPPLATINGLEVEL2,
     required_upgrade: Api::UpgradeId::TERRANVEHICLEANDSHIPARMORSLEVEL1},
   Api::UpgradeId::TERRANVEHICLEANDSHIPARMORSLEVEL3 =>
    {ability: Api::AbilityId::ARMORYRESEARCH_TERRANVEHICLEANDSHIPPLATINGLEVEL3,
     required_upgrade: Api::UpgradeId::TERRANVEHICLEANDSHIPARMORSLEVEL2}},
                                             Api::UnitTypeId::FUSIONCORE =>
  {Api::UpgradeId::BATTLECRUISERENABLESPECIALIZATIONS =>
    {ability: Api::AbilityId::RESEARCH_BATTLECRUISERWEAPONREFIT},
   Api::UpgradeId::LIBERATORAGRANGEUPGRADE =>
    {ability: Api::AbilityId::FUSIONCORERESEARCH_RESEARCHBALLISTICRANGE},
   Api::UpgradeId::MEDIVACCADUCEUSREACTOR =>
    {ability: Api::AbilityId::FUSIONCORERESEARCH_RESEARCHMEDIVACENERGYUPGRADE}},
                                             Api::UnitTypeId::BARRACKSTECHLAB =>
  {Api::UpgradeId::STIMPACK =>
    {ability: Api::AbilityId::BARRACKSTECHLABRESEARCH_STIMPACK},
   Api::UpgradeId::SHIELDWALL =>
    {ability: Api::AbilityId::RESEARCH_COMBATSHIELD},
   Api::UpgradeId::PUNISHERGRENADES =>
    {ability: Api::AbilityId::RESEARCH_CONCUSSIVESHELLS}},
                                             Api::UnitTypeId::FACTORYTECHLAB =>
  {Api::UpgradeId::HIGHCAPACITYBARRELS =>
    {ability: Api::AbilityId::RESEARCH_INFERNALPREIGNITER},
   Api::UpgradeId::TEMPESTGROUNDATTACKUPGRADE =>
    {ability: Api::AbilityId::FACTORYTECHLABRESEARCH_CYCLONERESEARCHHURRICANETHRUSTERS},
   Api::UpgradeId::DRILLCLAWS =>
    {ability: Api::AbilityId::RESEARCH_DRILLINGCLAWS,
     required_building: Api::UnitTypeId::ARMORY},
   Api::UpgradeId::SMARTSERVOS =>
    {ability: Api::AbilityId::RESEARCH_SMARTSERVOS,
     required_building: Api::UnitTypeId::ARMORY}},
                                             Api::UnitTypeId::STARPORTTECHLAB =>
  {Api::UpgradeId::BANSHEECLOAK =>
    {ability: Api::AbilityId::RESEARCH_BANSHEECLOAKINGFIELD},
   Api::UpgradeId::BANSHEESPEED =>
    {ability: Api::AbilityId::RESEARCH_BANSHEEHYPERFLIGHTROTORS},
   Api::UpgradeId::AMPLIFIEDSHIELDING =>
    {ability: Api::AbilityId::STARPORTTECHLABRESEARCH_RESEARCHRAVENINTERFERENCEMATRIX}},
                                             Api::UnitTypeId::FORGE =>
  {Api::UpgradeId::PROTOSSGROUNDWEAPONSLEVEL1 =>
    {ability: Api::AbilityId::FORGERESEARCH_PROTOSSGROUNDWEAPONSLEVEL1,
     requires_power: true},
   Api::UpgradeId::PROTOSSGROUNDARMORSLEVEL1 =>
    {ability: Api::AbilityId::FORGERESEARCH_PROTOSSGROUNDARMORLEVEL1,
     requires_power: true},
   Api::UpgradeId::PROTOSSSHIELDSLEVEL1 =>
    {ability: Api::AbilityId::FORGERESEARCH_PROTOSSSHIELDSLEVEL1,
     requires_power: true},
   Api::UpgradeId::PROTOSSGROUNDWEAPONSLEVEL2 =>
    {ability: Api::AbilityId::FORGERESEARCH_PROTOSSGROUNDWEAPONSLEVEL2,
     required_building: Api::UnitTypeId::TWILIGHTCOUNCIL,
     required_upgrade: Api::UpgradeId::PROTOSSGROUNDWEAPONSLEVEL1,
     requires_power: true},
   Api::UpgradeId::PROTOSSGROUNDWEAPONSLEVEL3 =>
    {ability: Api::AbilityId::FORGERESEARCH_PROTOSSGROUNDWEAPONSLEVEL3,
     required_building: Api::UnitTypeId::TWILIGHTCOUNCIL,
     required_upgrade: Api::UpgradeId::PROTOSSGROUNDWEAPONSLEVEL2,
     requires_power: true},
   Api::UpgradeId::PROTOSSGROUNDARMORSLEVEL2 =>
    {ability: Api::AbilityId::FORGERESEARCH_PROTOSSGROUNDARMORLEVEL2,
     required_building: Api::UnitTypeId::TWILIGHTCOUNCIL,
     required_upgrade: Api::UpgradeId::PROTOSSGROUNDARMORSLEVEL1,
     requires_power: true},
   Api::UpgradeId::PROTOSSGROUNDARMORSLEVEL3 =>
    {ability: Api::AbilityId::FORGERESEARCH_PROTOSSGROUNDARMORLEVEL3,
     required_building: Api::UnitTypeId::TWILIGHTCOUNCIL,
     required_upgrade: Api::UpgradeId::PROTOSSGROUNDARMORSLEVEL2,
     requires_power: true},
   Api::UpgradeId::PROTOSSSHIELDSLEVEL2 =>
    {ability: Api::AbilityId::FORGERESEARCH_PROTOSSSHIELDSLEVEL2,
     required_building: Api::UnitTypeId::TWILIGHTCOUNCIL,
     required_upgrade: Api::UpgradeId::PROTOSSSHIELDSLEVEL1,
     requires_power: true},
   Api::UpgradeId::PROTOSSSHIELDSLEVEL3 =>
    {ability: Api::AbilityId::FORGERESEARCH_PROTOSSSHIELDSLEVEL3,
     required_building: Api::UnitTypeId::TWILIGHTCOUNCIL,
     required_upgrade: Api::UpgradeId::PROTOSSSHIELDSLEVEL2,
     requires_power: true}},
                                             Api::UnitTypeId::FLEETBEACON =>
  {Api::UpgradeId::PHOENIXRANGEUPGRADE =>
    {ability: Api::AbilityId::RESEARCH_PHOENIXANIONPULSECRYSTALS,
     requires_power: true},
   Api::UpgradeId::VOIDRAYSPEEDUPGRADE =>
    {ability: Api::AbilityId::FLEETBEACONRESEARCH_RESEARCHVOIDRAYSPEEDUPGRADE,
     requires_power: true},
   Api::UpgradeId::MICROBIALSHROUD =>
    {ability: Api::AbilityId::FLEETBEACONRESEARCH_TEMPESTRESEARCHGROUNDATTACKUPGRADE,
     requires_power: true}},
                                             Api::UnitTypeId::TWILIGHTCOUNCIL =>
  {Api::UpgradeId::CHARGE =>
    {ability: Api::AbilityId::RESEARCH_CHARGE, requires_power: true},
   Api::UpgradeId::BLINKTECH =>
    {ability: Api::AbilityId::RESEARCH_BLINK, requires_power: true},
   Api::UpgradeId::ADEPTPIERCINGATTACK =>
    {ability: Api::AbilityId::RESEARCH_ADEPTRESONATINGGLAIVES,
     requires_power: true}},
                                             Api::UnitTypeId::TEMPLARARCHIVE =>
  {Api::UpgradeId::PSISTORMTECH =>
    {ability: Api::AbilityId::RESEARCH_PSISTORM, requires_power: true}},
                                             Api::UnitTypeId::DARKSHRINE =>
  {Api::UpgradeId::DARKTEMPLARBLINKUPGRADE =>
    {ability: Api::AbilityId::RESEARCH_SHADOWSTRIKE,
     requires_power: true}},
                                             Api::UnitTypeId::ROBOTICSBAY =>
  {Api::UpgradeId::OBSERVERGRAVITICBOOSTER =>
    {ability: Api::AbilityId::RESEARCH_GRAVITICBOOSTER,
     requires_power: true},
   Api::UpgradeId::GRAVITICDRIVE =>
    {ability: Api::AbilityId::RESEARCH_GRAVITICDRIVE,
     requires_power: true},
   Api::UpgradeId::EXTENDEDTHERMALLANCE =>
    {ability: Api::AbilityId::RESEARCH_EXTENDEDTHERMALLANCE,
     requires_power: true}},
                                             Api::UnitTypeId::CYBERNETICSCORE =>
  {Api::UpgradeId::PROTOSSAIRWEAPONSLEVEL1 =>
    {ability: Api::AbilityId::CYBERNETICSCORERESEARCH_PROTOSSAIRWEAPONSLEVEL1,
     requires_power: true},
   Api::UpgradeId::PROTOSSAIRARMORSLEVEL1 =>
    {ability: Api::AbilityId::CYBERNETICSCORERESEARCH_PROTOSSAIRARMORLEVEL1,
     requires_power: true},
   Api::UpgradeId::WARPGATERESEARCH =>
    {ability: Api::AbilityId::RESEARCH_WARPGATE, requires_power: true},
   Api::UpgradeId::PROTOSSAIRWEAPONSLEVEL2 =>
    {ability: Api::AbilityId::CYBERNETICSCORERESEARCH_PROTOSSAIRWEAPONSLEVEL2,
     required_building: Api::UnitTypeId::FLEETBEACON,
     required_upgrade: Api::UpgradeId::PROTOSSAIRWEAPONSLEVEL1,
     requires_power: true},
   Api::UpgradeId::PROTOSSAIRWEAPONSLEVEL3 =>
    {ability: Api::AbilityId::CYBERNETICSCORERESEARCH_PROTOSSAIRWEAPONSLEVEL3,
     required_building: Api::UnitTypeId::FLEETBEACON,
     required_upgrade: Api::UpgradeId::PROTOSSAIRWEAPONSLEVEL2,
     requires_power: true},
   Api::UpgradeId::PROTOSSAIRARMORSLEVEL2 =>
    {ability: Api::AbilityId::CYBERNETICSCORERESEARCH_PROTOSSAIRARMORLEVEL2,
     required_building: Api::UnitTypeId::FLEETBEACON,
     required_upgrade: Api::UpgradeId::PROTOSSAIRARMORSLEVEL1,
     requires_power: true},
   Api::UpgradeId::PROTOSSAIRARMORSLEVEL3 =>
    {ability: Api::AbilityId::CYBERNETICSCORERESEARCH_PROTOSSAIRARMORLEVEL3,
     required_building: Api::UnitTypeId::FLEETBEACON,
     required_upgrade: Api::UpgradeId::PROTOSSAIRARMORSLEVEL2,
     requires_power: true}},
                                             Api::UnitTypeId::HATCHERY =>
  {Api::UpgradeId::OVERLORDSPEED =>
    {ability: Api::AbilityId::RESEARCH_PNEUMATIZEDCARAPACE},
   Api::UpgradeId::BURROW => {ability: Api::AbilityId::RESEARCH_BURROW}},
                                             Api::UnitTypeId::SPAWNINGPOOL =>
  {Api::UpgradeId::ZERGLINGMOVEMENTSPEED =>
    {ability: Api::AbilityId::RESEARCH_ZERGLINGMETABOLICBOOST},
   Api::UpgradeId::ZERGLINGATTACKSPEED =>
    {ability: Api::AbilityId::RESEARCH_ZERGLINGADRENALGLANDS,
     required_building: Api::UnitTypeId::HIVE}},
                                             Api::UnitTypeId::EVOLUTIONCHAMBER =>
  {Api::UpgradeId::ZERGMELEEWEAPONSLEVEL1 =>
    {ability: Api::AbilityId::RESEARCH_ZERGMELEEWEAPONSLEVEL1},
   Api::UpgradeId::ZERGGROUNDARMORSLEVEL1 =>
    {ability: Api::AbilityId::RESEARCH_ZERGGROUNDARMORLEVEL1},
   Api::UpgradeId::ZERGMISSILEWEAPONSLEVEL1 =>
    {ability: Api::AbilityId::RESEARCH_ZERGMISSILEWEAPONSLEVEL1},
   Api::UpgradeId::ZERGMELEEWEAPONSLEVEL2 =>
    {ability: Api::AbilityId::RESEARCH_ZERGMELEEWEAPONSLEVEL2,
     required_building: Api::UnitTypeId::LAIR,
     required_upgrade: Api::UpgradeId::ZERGMELEEWEAPONSLEVEL1},
   Api::UpgradeId::ZERGMELEEWEAPONSLEVEL3 =>
    {ability: Api::AbilityId::RESEARCH_ZERGMELEEWEAPONSLEVEL3,
     required_building: Api::UnitTypeId::HIVE,
     required_upgrade: Api::UpgradeId::ZERGMELEEWEAPONSLEVEL2},
   Api::UpgradeId::ZERGGROUNDARMORSLEVEL2 =>
    {ability: Api::AbilityId::RESEARCH_ZERGGROUNDARMORLEVEL2,
     required_building: Api::UnitTypeId::LAIR,
     required_upgrade: Api::UpgradeId::ZERGGROUNDARMORSLEVEL1},
   Api::UpgradeId::ZERGGROUNDARMORSLEVEL3 =>
    {ability: Api::AbilityId::RESEARCH_ZERGGROUNDARMORLEVEL3,
     required_building: Api::UnitTypeId::HIVE,
     required_upgrade: Api::UpgradeId::ZERGGROUNDARMORSLEVEL2},
   Api::UpgradeId::ZERGMISSILEWEAPONSLEVEL2 =>
    {ability: Api::AbilityId::RESEARCH_ZERGMISSILEWEAPONSLEVEL2,
     required_building: Api::UnitTypeId::LAIR,
     required_upgrade: Api::UpgradeId::ZERGMISSILEWEAPONSLEVEL1},
   Api::UpgradeId::ZERGMISSILEWEAPONSLEVEL3 =>
    {ability: Api::AbilityId::RESEARCH_ZERGMISSILEWEAPONSLEVEL3,
     required_building: Api::UnitTypeId::HIVE,
     required_upgrade: Api::UpgradeId::ZERGMISSILEWEAPONSLEVEL2}},
                                             Api::UnitTypeId::HYDRALISKDEN =>
  {Api::UpgradeId::EVOLVEGROOVEDSPINES =>
    {ability: Api::AbilityId::RESEARCH_GROOVEDSPINES},
   Api::UpgradeId::EVOLVEMUSCULARAUGMENTS =>
    {ability: Api::AbilityId::RESEARCH_MUSCULARAUGMENTS}},
                                             Api::UnitTypeId::SPIRE =>
  {Api::UpgradeId::ZERGFLYERWEAPONSLEVEL1 =>
    {ability: Api::AbilityId::RESEARCH_ZERGFLYERATTACKLEVEL1},
   Api::UpgradeId::ZERGFLYERARMORSLEVEL1 =>
    {ability: Api::AbilityId::RESEARCH_ZERGFLYERARMORLEVEL1},
   Api::UpgradeId::ZERGFLYERWEAPONSLEVEL2 =>
    {ability: Api::AbilityId::RESEARCH_ZERGFLYERATTACKLEVEL2,
     required_building: Api::UnitTypeId::LAIR,
     required_upgrade: Api::UpgradeId::ZERGFLYERWEAPONSLEVEL1},
   Api::UpgradeId::ZERGFLYERWEAPONSLEVEL3 =>
    {ability: Api::AbilityId::RESEARCH_ZERGFLYERATTACKLEVEL3,
     required_building: Api::UnitTypeId::HIVE,
     required_upgrade: Api::UpgradeId::ZERGFLYERWEAPONSLEVEL2},
   Api::UpgradeId::ZERGFLYERARMORSLEVEL2 =>
    {ability: Api::AbilityId::RESEARCH_ZERGFLYERARMORLEVEL2,
     required_building: Api::UnitTypeId::LAIR,
     required_upgrade: Api::UpgradeId::ZERGFLYERARMORSLEVEL1},
   Api::UpgradeId::ZERGFLYERARMORSLEVEL3 =>
    {ability: Api::AbilityId::RESEARCH_ZERGFLYERARMORLEVEL3,
     required_building: Api::UnitTypeId::HIVE,
     required_upgrade: Api::UpgradeId::ZERGFLYERARMORSLEVEL2}},
                                             Api::UnitTypeId::ULTRALISKCAVERN =>
  {Api::UpgradeId::ANABOLICSYNTHESIS =>
    {ability: Api::AbilityId::RESEARCH_ANABOLICSYNTHESIS},
   Api::UpgradeId::CHITINOUSPLATING =>
    {ability: Api::AbilityId::RESEARCH_CHITINOUSPLATING}},
                                             Api::UnitTypeId::INFESTATIONPIT =>
  {Api::UpgradeId::NEURALPARASITE =>
    {ability: Api::AbilityId::RESEARCH_NEURALPARASITE}},
                                             Api::UnitTypeId::BANELINGNEST =>
  {Api::UpgradeId::CENTRIFICALHOOKS =>
    {ability: Api::AbilityId::RESEARCH_CENTRIFUGALHOOKS,
     required_building: Api::UnitTypeId::LAIR}},
                                             Api::UnitTypeId::ROACHWARREN =>
  {Api::UpgradeId::GLIALRECONSTITUTION =>
    {ability: Api::AbilityId::RESEARCH_GLIALREGENERATION,
     required_building: Api::UnitTypeId::LAIR},
   Api::UpgradeId::TUNNELINGCLAWS =>
    {ability: Api::AbilityId::RESEARCH_TUNNELINGCLAWS,
     required_building: Api::UnitTypeId::LAIR}},
                                             Api::UnitTypeId::LAIR =>
  {Api::UpgradeId::OVERLORDSPEED =>
    {ability: Api::AbilityId::RESEARCH_PNEUMATIZEDCARAPACE},
   Api::UpgradeId::BURROW => {ability: Api::AbilityId::RESEARCH_BURROW}},
                                             Api::UnitTypeId::HIVE =>
  {Api::UpgradeId::OVERLORDSPEED =>
    {ability: Api::AbilityId::RESEARCH_PNEUMATIZEDCARAPACE},
   Api::UpgradeId::BURROW => {ability: Api::AbilityId::RESEARCH_BURROW}},
                                             Api::UnitTypeId::GREATERSPIRE =>
  {Api::UpgradeId::ZERGFLYERWEAPONSLEVEL1 =>
    {ability: Api::AbilityId::RESEARCH_ZERGFLYERATTACKLEVEL1},
   Api::UpgradeId::ZERGFLYERARMORSLEVEL1 =>
    {ability: Api::AbilityId::RESEARCH_ZERGFLYERARMORLEVEL1},
   Api::UpgradeId::ZERGFLYERWEAPONSLEVEL2 =>
    {ability: Api::AbilityId::RESEARCH_ZERGFLYERATTACKLEVEL2,
     required_building: Api::UnitTypeId::LAIR,
     required_upgrade: Api::UpgradeId::ZERGFLYERWEAPONSLEVEL1},
   Api::UpgradeId::ZERGFLYERWEAPONSLEVEL3 =>
    {ability: Api::AbilityId::RESEARCH_ZERGFLYERATTACKLEVEL3,
     required_building: Api::UnitTypeId::HIVE,
     required_upgrade: Api::UpgradeId::ZERGFLYERWEAPONSLEVEL2},
   Api::UpgradeId::ZERGFLYERARMORSLEVEL2 =>
    {ability: Api::AbilityId::RESEARCH_ZERGFLYERARMORLEVEL2,
     required_building: Api::UnitTypeId::LAIR,
     required_upgrade: Api::UpgradeId::ZERGFLYERARMORSLEVEL1},
   Api::UpgradeId::ZERGFLYERARMORSLEVEL3 =>
    {ability: Api::AbilityId::RESEARCH_ZERGFLYERARMORLEVEL3,
     required_building: Api::UnitTypeId::HIVE,
     required_upgrade: Api::UpgradeId::ZERGFLYERARMORSLEVEL2}},
                                             Api::UnitTypeId::LURKERDENMP =>
  {Api::UpgradeId::DIGGINGCLAWS =>
    {ability: Api::AbilityId::RESEARCH_ADAPTIVETALONS,
     required_building: Api::UnitTypeId::HIVE},
   Api::UpgradeId::LURKERRANGE =>
    {ability: Api::AbilityId::LURKERDENRESEARCH_RESEARCHLURKERRANGE,
     required_building: Api::UnitTypeId::HIVE}}}

      # unit_created_from_data = {
      #   UnitTypeId.ADEPT: [UnitTypeId.GATEWAY, UnitTypeId.WARPGATE],
      #   UnitTypeId.ARMORY: [UnitTypeId.SCV],
      #   UnitTypeId.ASSIMILATOR: [UnitTypeId.PROBE],
      # }
      def unit_created_from_data = {Api::UnitTypeId::SCV =>
  [Api::UnitTypeId::COMMANDCENTER,
    Api::UnitTypeId::PLANETARYFORTRESS,
    Api::UnitTypeId::ORBITALCOMMAND],
                                    Api::UnitTypeId::PLANETARYFORTRESS => [Api::UnitTypeId::COMMANDCENTER],
                                    Api::UnitTypeId::ORBITALCOMMAND => [Api::UnitTypeId::COMMANDCENTER],
                                    Api::UnitTypeId::MARINE => [Api::UnitTypeId::BARRACKS],
                                    Api::UnitTypeId::REAPER => [Api::UnitTypeId::BARRACKS],
                                    Api::UnitTypeId::GHOST => [Api::UnitTypeId::BARRACKS],
                                    Api::UnitTypeId::MARAUDER => [Api::UnitTypeId::BARRACKS],
                                    Api::UnitTypeId::HELLION => [Api::UnitTypeId::FACTORY],
                                    Api::UnitTypeId::CYCLONE => [Api::UnitTypeId::FACTORY],
                                    Api::UnitTypeId::WIDOWMINE => [Api::UnitTypeId::FACTORY],
                                    Api::UnitTypeId::SIEGETANK => [Api::UnitTypeId::FACTORY],
                                    Api::UnitTypeId::THOR => [Api::UnitTypeId::FACTORY],
                                    Api::UnitTypeId::HELLIONTANK => [Api::UnitTypeId::FACTORY],
                                    Api::UnitTypeId::MEDIVAC => [Api::UnitTypeId::STARPORT],
                                    Api::UnitTypeId::VIKINGFIGHTER => [Api::UnitTypeId::STARPORT],
                                    Api::UnitTypeId::LIBERATOR => [Api::UnitTypeId::STARPORT],
                                    Api::UnitTypeId::BANSHEE => [Api::UnitTypeId::STARPORT],
                                    Api::UnitTypeId::RAVEN => [Api::UnitTypeId::STARPORT],
                                    Api::UnitTypeId::BATTLECRUISER => [Api::UnitTypeId::STARPORT],
                                    Api::UnitTypeId::COMMANDCENTER => [Api::UnitTypeId::SCV],
                                    Api::UnitTypeId::SUPPLYDEPOT => [Api::UnitTypeId::SCV],
                                    Api::UnitTypeId::REFINERY => [Api::UnitTypeId::SCV],
                                    Api::UnitTypeId::BARRACKS => [Api::UnitTypeId::SCV],
                                    Api::UnitTypeId::ENGINEERINGBAY => [Api::UnitTypeId::SCV],
                                    Api::UnitTypeId::MISSILETURRET => [Api::UnitTypeId::SCV],
                                    Api::UnitTypeId::BUNKER => [Api::UnitTypeId::SCV],
                                    Api::UnitTypeId::SENSORTOWER => [Api::UnitTypeId::SCV],
                                    Api::UnitTypeId::GHOSTACADEMY => [Api::UnitTypeId::SCV],
                                    Api::UnitTypeId::FACTORY => [Api::UnitTypeId::SCV],
                                    Api::UnitTypeId::STARPORT => [Api::UnitTypeId::SCV],
                                    Api::UnitTypeId::ARMORY => [Api::UnitTypeId::SCV],
                                    Api::UnitTypeId::FUSIONCORE => [Api::UnitTypeId::SCV],
                                    Api::UnitTypeId::AUTOTURRET => [Api::UnitTypeId::RAVEN],
                                    Api::UnitTypeId::PROBE => [Api::UnitTypeId::NEXUS],
                                    Api::UnitTypeId::MOTHERSHIP => [Api::UnitTypeId::NEXUS],
                                    Api::UnitTypeId::ZEALOT =>
  [Api::UnitTypeId::GATEWAY, Api::UnitTypeId::WARPGATE],
                                    Api::UnitTypeId::STALKER =>
  [Api::UnitTypeId::GATEWAY, Api::UnitTypeId::WARPGATE],
                                    Api::UnitTypeId::HIGHTEMPLAR =>
  [Api::UnitTypeId::GATEWAY, Api::UnitTypeId::WARPGATE],
                                    Api::UnitTypeId::DARKTEMPLAR =>
  [Api::UnitTypeId::GATEWAY, Api::UnitTypeId::WARPGATE],
                                    Api::UnitTypeId::SENTRY =>
  [Api::UnitTypeId::GATEWAY, Api::UnitTypeId::WARPGATE],
                                    Api::UnitTypeId::ADEPT =>
  [Api::UnitTypeId::GATEWAY, Api::UnitTypeId::WARPGATE],
                                    Api::UnitTypeId::PHOENIX => [Api::UnitTypeId::STARGATE],
                                    Api::UnitTypeId::VOIDRAY => [Api::UnitTypeId::STARGATE],
                                    Api::UnitTypeId::ORACLE => [Api::UnitTypeId::STARGATE],
                                    Api::UnitTypeId::CARRIER => [Api::UnitTypeId::STARGATE],
                                    Api::UnitTypeId::TEMPEST => [Api::UnitTypeId::STARGATE],
                                    Api::UnitTypeId::WARPPRISM => [Api::UnitTypeId::ROBOTICSFACILITY],
                                    Api::UnitTypeId::OBSERVER => [Api::UnitTypeId::ROBOTICSFACILITY],
                                    Api::UnitTypeId::IMMORTAL => [Api::UnitTypeId::ROBOTICSFACILITY],
                                    Api::UnitTypeId::COLOSSUS => [Api::UnitTypeId::ROBOTICSFACILITY],
                                    Api::UnitTypeId::DISRUPTOR => [Api::UnitTypeId::ROBOTICSFACILITY],
                                    Api::UnitTypeId::NEXUS => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::PYLON => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::ASSIMILATOR => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::GATEWAY => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::FORGE => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::FLEETBEACON => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::TWILIGHTCOUNCIL => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::PHOTONCANNON => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::STARGATE => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::TEMPLARARCHIVE => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::DARKSHRINE => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::ROBOTICSBAY => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::ROBOTICSFACILITY => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::CYBERNETICSCORE => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::SHIELDBATTERY => [Api::UnitTypeId::PROBE],
                                    Api::UnitTypeId::LAIR => [Api::UnitTypeId::HATCHERY],
                                    Api::UnitTypeId::QUEEN =>
  [Api::UnitTypeId::HATCHERY,
    Api::UnitTypeId::LAIR,
    Api::UnitTypeId::HIVE],
                                    Api::UnitTypeId::GREATERSPIRE => [Api::UnitTypeId::SPIRE],
                                    Api::UnitTypeId::NYDUSCANAL => [Api::UnitTypeId::NYDUSNETWORK],
                                    Api::UnitTypeId::HIVE => [Api::UnitTypeId::LAIR],
                                    Api::UnitTypeId::HATCHERY => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::EXTRACTOR => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::SPAWNINGPOOL => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::EVOLUTIONCHAMBER => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::HYDRALISKDEN => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::SPIRE => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::ULTRALISKCAVERN => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::INFESTATIONPIT => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::NYDUSNETWORK => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::BANELINGNEST => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::LURKERDENMP => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::ROACHWARREN => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::SPINECRAWLER => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::SPORECRAWLER => [Api::UnitTypeId::DRONE],
                                    Api::UnitTypeId::OVERSEER =>
  [Api::UnitTypeId::OVERLORD, Api::UnitTypeId::OVERLORDTRANSPORT],
                                    Api::UnitTypeId::OVERLORDTRANSPORT => [Api::UnitTypeId::OVERLORD],
                                    Api::UnitTypeId::LURKERMP => [Api::UnitTypeId::HYDRALISK],
                                    Api::UnitTypeId::RAVAGER => [Api::UnitTypeId::ROACH],
                                    Api::UnitTypeId::BROODLORD => [Api::UnitTypeId::CORRUPTOR],
                                    Api::UnitTypeId::CREEPTUMORQUEEN => [Api::UnitTypeId::QUEEN],
                                    Api::UnitTypeId::CREEPTUMOR =>
  [Api::UnitTypeId::QUEEN,
    Api::UnitTypeId::CREEPTUMORBURROWED,
    Api::UnitTypeId::CREEPTUMORQUEEN],
                                    Api::UnitTypeId::CHANGELING =>
  [Api::UnitTypeId::OVERSEER, Api::UnitTypeId::OVERSEERSIEGEMODE],
                                    Api::UnitTypeId::DRONE => [Api::UnitTypeId::LARVA],
                                    Api::UnitTypeId::OVERLORD => [Api::UnitTypeId::LARVA],
                                    Api::UnitTypeId::ZERGLING => [Api::UnitTypeId::LARVA],
                                    Api::UnitTypeId::HYDRALISK => [Api::UnitTypeId::LARVA],
                                    Api::UnitTypeId::MUTALISK => [Api::UnitTypeId::LARVA],
                                    Api::UnitTypeId::ULTRALISK => [Api::UnitTypeId::LARVA],
                                    Api::UnitTypeId::ROACH => [Api::UnitTypeId::LARVA],
                                    Api::UnitTypeId::INFESTOR => [Api::UnitTypeId::LARVA],
                                    Api::UnitTypeId::CORRUPTOR => [Api::UnitTypeId::LARVA],
                                    Api::UnitTypeId::VIPER => [Api::UnitTypeId::LARVA],
                                    Api::UnitTypeId::SWARMHOSTMP => [Api::UnitTypeId::LARVA],
                                    Api::UnitTypeId::LOCUSTMPFLYING =>
  [Api::UnitTypeId::SWARMHOSTBURROWEDMP, Api::UnitTypeId::SWARMHOSTMP],
                                    Api::UnitTypeId::ORACLESTASISTRAP => [Api::UnitTypeId::ORACLE]}

      # unit_created_from_data = {
      #   UpgradeId.ADEPTPIERCINGATTACK: UnitTypeId.TWILIGHTCOUNCIL,
      #   UpgradeId.ANABOLICSYNTHESIS: UnitTypeId.ULTRALISKCAVERN,
      #   UpgradeId.BANSHEECLOAK: UnitTypeId.STARPORTTECHLAB,
      # }
      def upgrade_researched_from_data = {Api::UpgradeId::HISECAUTOTRACKING => Api::UnitTypeId::ENGINEERINGBAY,
                                          Api::UpgradeId::TERRANBUILDINGARMOR => Api::UnitTypeId::ENGINEERINGBAY,
                                          Api::UpgradeId::TERRANINFANTRYWEAPONSLEVEL1 =>
  Api::UnitTypeId::ENGINEERINGBAY,
                                          Api::UpgradeId::TERRANINFANTRYARMORSLEVEL1 =>
  Api::UnitTypeId::ENGINEERINGBAY,
                                          Api::UpgradeId::TERRANINFANTRYWEAPONSLEVEL2 =>
  Api::UnitTypeId::ENGINEERINGBAY,
                                          Api::UpgradeId::TERRANINFANTRYWEAPONSLEVEL3 =>
  Api::UnitTypeId::ENGINEERINGBAY,
                                          Api::UpgradeId::TERRANINFANTRYARMORSLEVEL2 =>
  Api::UnitTypeId::ENGINEERINGBAY,
                                          Api::UpgradeId::TERRANINFANTRYARMORSLEVEL3 =>
  Api::UnitTypeId::ENGINEERINGBAY,
                                          Api::UpgradeId::PERSONALCLOAKING => Api::UnitTypeId::GHOSTACADEMY,
                                          Api::UpgradeId::TERRANVEHICLEWEAPONSLEVEL1 => Api::UnitTypeId::ARMORY,
                                          Api::UpgradeId::TERRANSHIPWEAPONSLEVEL1 => Api::UnitTypeId::ARMORY,
                                          Api::UpgradeId::TERRANVEHICLEANDSHIPARMORSLEVEL1 => Api::UnitTypeId::ARMORY,
                                          Api::UpgradeId::TERRANVEHICLEWEAPONSLEVEL2 => Api::UnitTypeId::ARMORY,
                                          Api::UpgradeId::TERRANVEHICLEWEAPONSLEVEL3 => Api::UnitTypeId::ARMORY,
                                          Api::UpgradeId::TERRANSHIPWEAPONSLEVEL2 => Api::UnitTypeId::ARMORY,
                                          Api::UpgradeId::TERRANSHIPWEAPONSLEVEL3 => Api::UnitTypeId::ARMORY,
                                          Api::UpgradeId::TERRANVEHICLEANDSHIPARMORSLEVEL2 => Api::UnitTypeId::ARMORY,
                                          Api::UpgradeId::TERRANVEHICLEANDSHIPARMORSLEVEL3 => Api::UnitTypeId::ARMORY,
                                          Api::UpgradeId::BATTLECRUISERENABLESPECIALIZATIONS =>
  Api::UnitTypeId::FUSIONCORE,
                                          Api::UpgradeId::LIBERATORAGRANGEUPGRADE => Api::UnitTypeId::FUSIONCORE,
                                          Api::UpgradeId::MEDIVACCADUCEUSREACTOR => Api::UnitTypeId::FUSIONCORE,
                                          Api::UpgradeId::STIMPACK => Api::UnitTypeId::BARRACKSTECHLAB,
                                          Api::UpgradeId::SHIELDWALL => Api::UnitTypeId::BARRACKSTECHLAB,
                                          Api::UpgradeId::PUNISHERGRENADES => Api::UnitTypeId::BARRACKSTECHLAB,
                                          Api::UpgradeId::HIGHCAPACITYBARRELS => Api::UnitTypeId::FACTORYTECHLAB,
                                          Api::UpgradeId::TEMPESTGROUNDATTACKUPGRADE =>
  Api::UnitTypeId::FACTORYTECHLAB,
                                          Api::UpgradeId::DRILLCLAWS => Api::UnitTypeId::FACTORYTECHLAB,
                                          Api::UpgradeId::SMARTSERVOS => Api::UnitTypeId::FACTORYTECHLAB,
                                          Api::UpgradeId::BANSHEECLOAK => Api::UnitTypeId::STARPORTTECHLAB,
                                          Api::UpgradeId::BANSHEESPEED => Api::UnitTypeId::STARPORTTECHLAB,
                                          Api::UpgradeId::AMPLIFIEDSHIELDING => Api::UnitTypeId::STARPORTTECHLAB,
                                          Api::UpgradeId::PROTOSSGROUNDWEAPONSLEVEL1 => Api::UnitTypeId::FORGE,
                                          Api::UpgradeId::PROTOSSGROUNDARMORSLEVEL1 => Api::UnitTypeId::FORGE,
                                          Api::UpgradeId::PROTOSSSHIELDSLEVEL1 => Api::UnitTypeId::FORGE,
                                          Api::UpgradeId::PROTOSSGROUNDWEAPONSLEVEL2 => Api::UnitTypeId::FORGE,
                                          Api::UpgradeId::PROTOSSGROUNDWEAPONSLEVEL3 => Api::UnitTypeId::FORGE,
                                          Api::UpgradeId::PROTOSSGROUNDARMORSLEVEL2 => Api::UnitTypeId::FORGE,
                                          Api::UpgradeId::PROTOSSGROUNDARMORSLEVEL3 => Api::UnitTypeId::FORGE,
                                          Api::UpgradeId::PROTOSSSHIELDSLEVEL2 => Api::UnitTypeId::FORGE,
                                          Api::UpgradeId::PROTOSSSHIELDSLEVEL3 => Api::UnitTypeId::FORGE,
                                          Api::UpgradeId::PHOENIXRANGEUPGRADE => Api::UnitTypeId::FLEETBEACON,
                                          Api::UpgradeId::VOIDRAYSPEEDUPGRADE => Api::UnitTypeId::FLEETBEACON,
                                          Api::UpgradeId::MICROBIALSHROUD => Api::UnitTypeId::FLEETBEACON,
                                          Api::UpgradeId::CHARGE => Api::UnitTypeId::TWILIGHTCOUNCIL,
                                          Api::UpgradeId::BLINKTECH => Api::UnitTypeId::TWILIGHTCOUNCIL,
                                          Api::UpgradeId::ADEPTPIERCINGATTACK => Api::UnitTypeId::TWILIGHTCOUNCIL,
                                          Api::UpgradeId::PSISTORMTECH => Api::UnitTypeId::TEMPLARARCHIVE,
                                          Api::UpgradeId::DARKTEMPLARBLINKUPGRADE => Api::UnitTypeId::DARKSHRINE,
                                          Api::UpgradeId::OBSERVERGRAVITICBOOSTER => Api::UnitTypeId::ROBOTICSBAY,
                                          Api::UpgradeId::GRAVITICDRIVE => Api::UnitTypeId::ROBOTICSBAY,
                                          Api::UpgradeId::EXTENDEDTHERMALLANCE => Api::UnitTypeId::ROBOTICSBAY,
                                          Api::UpgradeId::PROTOSSAIRWEAPONSLEVEL1 => Api::UnitTypeId::CYBERNETICSCORE,
                                          Api::UpgradeId::PROTOSSAIRARMORSLEVEL1 => Api::UnitTypeId::CYBERNETICSCORE,
                                          Api::UpgradeId::WARPGATERESEARCH => Api::UnitTypeId::CYBERNETICSCORE,
                                          Api::UpgradeId::PROTOSSAIRWEAPONSLEVEL2 => Api::UnitTypeId::CYBERNETICSCORE,
                                          Api::UpgradeId::PROTOSSAIRWEAPONSLEVEL3 => Api::UnitTypeId::CYBERNETICSCORE,
                                          Api::UpgradeId::PROTOSSAIRARMORSLEVEL2 => Api::UnitTypeId::CYBERNETICSCORE,
                                          Api::UpgradeId::PROTOSSAIRARMORSLEVEL3 => Api::UnitTypeId::CYBERNETICSCORE,
                                          Api::UpgradeId::OVERLORDSPEED => Api::UnitTypeId::HATCHERY,
                                          Api::UpgradeId::BURROW => Api::UnitTypeId::HATCHERY,
                                          Api::UpgradeId::ZERGLINGMOVEMENTSPEED => Api::UnitTypeId::SPAWNINGPOOL,
                                          Api::UpgradeId::ZERGLINGATTACKSPEED => Api::UnitTypeId::SPAWNINGPOOL,
                                          Api::UpgradeId::ZERGMELEEWEAPONSLEVEL1 => Api::UnitTypeId::EVOLUTIONCHAMBER,
                                          Api::UpgradeId::ZERGGROUNDARMORSLEVEL1 => Api::UnitTypeId::EVOLUTIONCHAMBER,
                                          Api::UpgradeId::ZERGMISSILEWEAPONSLEVEL1 =>
  Api::UnitTypeId::EVOLUTIONCHAMBER,
                                          Api::UpgradeId::ZERGMELEEWEAPONSLEVEL2 => Api::UnitTypeId::EVOLUTIONCHAMBER,
                                          Api::UpgradeId::ZERGMELEEWEAPONSLEVEL3 => Api::UnitTypeId::EVOLUTIONCHAMBER,
                                          Api::UpgradeId::ZERGGROUNDARMORSLEVEL2 => Api::UnitTypeId::EVOLUTIONCHAMBER,
                                          Api::UpgradeId::ZERGGROUNDARMORSLEVEL3 => Api::UnitTypeId::EVOLUTIONCHAMBER,
                                          Api::UpgradeId::ZERGMISSILEWEAPONSLEVEL2 =>
  Api::UnitTypeId::EVOLUTIONCHAMBER,
                                          Api::UpgradeId::ZERGMISSILEWEAPONSLEVEL3 =>
  Api::UnitTypeId::EVOLUTIONCHAMBER,
                                          Api::UpgradeId::EVOLVEGROOVEDSPINES => Api::UnitTypeId::HYDRALISKDEN,
                                          Api::UpgradeId::EVOLVEMUSCULARAUGMENTS => Api::UnitTypeId::HYDRALISKDEN,
                                          Api::UpgradeId::ZERGFLYERWEAPONSLEVEL1 => Api::UnitTypeId::SPIRE,
                                          Api::UpgradeId::ZERGFLYERARMORSLEVEL1 => Api::UnitTypeId::SPIRE,
                                          Api::UpgradeId::ZERGFLYERWEAPONSLEVEL2 => Api::UnitTypeId::SPIRE,
                                          Api::UpgradeId::ZERGFLYERWEAPONSLEVEL3 => Api::UnitTypeId::SPIRE,
                                          Api::UpgradeId::ZERGFLYERARMORSLEVEL2 => Api::UnitTypeId::SPIRE,
                                          Api::UpgradeId::ZERGFLYERARMORSLEVEL3 => Api::UnitTypeId::SPIRE,
                                          Api::UpgradeId::ANABOLICSYNTHESIS => Api::UnitTypeId::ULTRALISKCAVERN,
                                          Api::UpgradeId::CHITINOUSPLATING => Api::UnitTypeId::ULTRALISKCAVERN,
                                          Api::UpgradeId::NEURALPARASITE => Api::UnitTypeId::INFESTATIONPIT,
                                          Api::UpgradeId::CENTRIFICALHOOKS => Api::UnitTypeId::BANELINGNEST,
                                          Api::UpgradeId::GLIALRECONSTITUTION => Api::UnitTypeId::ROACHWARREN,
                                          Api::UpgradeId::TUNNELINGCLAWS => Api::UnitTypeId::ROACHWARREN,
                                          Api::UpgradeId::DIGGINGCLAWS => Api::UnitTypeId::LURKERDENMP,
                                          Api::UpgradeId::LURKERRANGE => Api::UnitTypeId::LURKERDENMP}

      def unit_abilities_data = {Api::UnitTypeId::COLOSSUS =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::TECHLAB =>
  [Api::AbilityId::BARRACKSTECHLABRESEARCH_STIMPACK,
    Api::AbilityId::RESEARCH_COMBATSHIELD,
    Api::AbilityId::RESEARCH_CONCUSSIVESHELLS,
    Api::AbilityId::RESEARCH_INFERNALPREIGNITER,
    Api::AbilityId::RESEARCH_DRILLINGCLAWS,
    Api::AbilityId::RESEARCH_RAVENCORVIDREACTOR,
    Api::AbilityId::RESEARCH_BANSHEECLOAKINGFIELD],
                                 Api::UnitTypeId::REACTOR => [],
                                 Api::UnitTypeId::INFESTORTERRAN =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART,
    Api::AbilityId::BURROWDOWN_INFESTORTERRAN],
                                 Api::UnitTypeId::BANELINGCOCOON =>
  [Api::AbilityId::RALLY_BUILDING, Api::AbilityId::SMART],
                                 Api::UnitTypeId::BANELING =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::EXPLODE_EXPLODE,
    Api::AbilityId::BEHAVIOR_BUILDINGATTACKON,
    Api::AbilityId::SMART,
    Api::AbilityId::BURROWDOWN_BANELING],
                                 Api::UnitTypeId::MOTHERSHIP =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::EFFECT_MASSRECALL_STRATEGICRECALL,
    Api::AbilityId::EFFECT_TIMEWARP,
    Api::AbilityId._250MMSTRIKECANNONS_CANCEL,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::POINTDEFENSEDRONE => [],
                                 Api::UnitTypeId::CHANGELING =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::CHANGELINGZEALOT =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::CHANGELINGMARINESHIELD =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::CHANGELINGMARINE =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::CHANGELINGZERGLINGWINGS =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::CHANGELINGZERGLING =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::COMMANDCENTER =>
  [Api::AbilityId::RALLY_COMMANDCENTER,
    Api::AbilityId::LOADALL_COMMANDCENTER,
    Api::AbilityId::LIFT_COMMANDCENTER,
    Api::AbilityId::COMMANDCENTERTRAIN_SCV,
    Api::AbilityId::SMART,
    Api::AbilityId::UPGRADETOPLANETARYFORTRESS_PLANETARYFORTRESS,
    Api::AbilityId::UPGRADETOORBITAL_ORBITALCOMMAND],
                                 Api::UnitTypeId::SUPPLYDEPOT => [Api::AbilityId::MORPH_SUPPLYDEPOT_LOWER],
                                 Api::UnitTypeId::REFINERY => [],
                                 Api::UnitTypeId::BARRACKS =>
  [Api::AbilityId::RALLY_BUILDING,
    Api::AbilityId::BUILD_TECHLAB_BARRACKS,
    Api::AbilityId::BUILD_REACTOR_BARRACKS,
    Api::AbilityId::LIFT_BARRACKS,
    Api::AbilityId::BARRACKSTRAIN_MARINE,
    Api::AbilityId::BARRACKSTRAIN_REAPER,
    Api::AbilityId::SMART,
    Api::AbilityId::BARRACKSTRAIN_GHOST,
    Api::AbilityId::BARRACKSTRAIN_MARAUDER],
                                 Api::UnitTypeId::ENGINEERINGBAY =>
  [Api::AbilityId::RESEARCH_HISECAUTOTRACKING,
    Api::AbilityId::RESEARCH_TERRANSTRUCTUREARMORUPGRADE,
    Api::AbilityId::ENGINEERINGBAYRESEARCH_TERRANINFANTRYWEAPONSLEVEL1,
    Api::AbilityId::ENGINEERINGBAYRESEARCH_TERRANINFANTRYARMORLEVEL1,
    Api::AbilityId::ENGINEERINGBAYRESEARCH_TERRANINFANTRYWEAPONSLEVEL2,
    Api::AbilityId::ENGINEERINGBAYRESEARCH_TERRANINFANTRYWEAPONSLEVEL3,
    Api::AbilityId::ENGINEERINGBAYRESEARCH_TERRANINFANTRYARMORLEVEL2,
    Api::AbilityId::ENGINEERINGBAYRESEARCH_TERRANINFANTRYARMORLEVEL3],
                                 Api::UnitTypeId::MISSILETURRET =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::BUNKER =>
  [Api::AbilityId::EFFECT_SALVAGE,
    Api::AbilityId::RALLY_BUILDING,
    Api::AbilityId::LOAD_BUNKER,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::SENSORTOWER => [],
                                 Api::UnitTypeId::GHOSTACADEMY =>
  [Api::AbilityId::RESEARCH_PERSONALCLOAKING, Api::AbilityId::BUILD_NUKE],
                                 Api::UnitTypeId::FACTORY =>
  [Api::AbilityId::RALLY_BUILDING,
    Api::AbilityId::BUILD_TECHLAB_FACTORY,
    Api::AbilityId::BUILD_REACTOR_FACTORY,
    Api::AbilityId::LIFT_FACTORY,
    Api::AbilityId::FACTORYTRAIN_HELLION,
    Api::AbilityId::TRAIN_CYCLONE,
    Api::AbilityId::FACTORYTRAIN_WIDOWMINE,
    Api::AbilityId::SMART,
    Api::AbilityId::FACTORYTRAIN_SIEGETANK,
    Api::AbilityId::FACTORYTRAIN_THOR,
    Api::AbilityId::TRAIN_HELLBAT],
                                 Api::UnitTypeId::STARPORT =>
  [Api::AbilityId::RALLY_BUILDING,
    Api::AbilityId::BUILD_TECHLAB_STARPORT,
    Api::AbilityId::BUILD_REACTOR_STARPORT,
    Api::AbilityId::LIFT_STARPORT,
    Api::AbilityId::STARPORTTRAIN_MEDIVAC,
    Api::AbilityId::STARPORTTRAIN_VIKINGFIGHTER,
    Api::AbilityId::STARPORTTRAIN_LIBERATOR,
    Api::AbilityId::SMART,
    Api::AbilityId::STARPORTTRAIN_BANSHEE,
    Api::AbilityId::STARPORTTRAIN_RAVEN,
    Api::AbilityId::STARPORTTRAIN_BATTLECRUISER],
                                 Api::UnitTypeId::ARMORY =>
  [Api::AbilityId::ARMORYRESEARCH_TERRANVEHICLEWEAPONSLEVEL1,
    Api::AbilityId::ARMORYRESEARCH_TERRANSHIPWEAPONSLEVEL1,
    Api::AbilityId::ARMORYRESEARCH_TERRANVEHICLEANDSHIPPLATINGLEVEL1,
    Api::AbilityId::ARMORYRESEARCH_TERRANVEHICLEWEAPONSLEVEL2,
    Api::AbilityId::ARMORYRESEARCH_TERRANVEHICLEWEAPONSLEVEL3,
    Api::AbilityId::ARMORYRESEARCH_TERRANSHIPWEAPONSLEVEL2,
    Api::AbilityId::ARMORYRESEARCH_TERRANSHIPWEAPONSLEVEL3,
    Api::AbilityId::ARMORYRESEARCH_TERRANVEHICLEANDSHIPPLATINGLEVEL2,
    Api::AbilityId::ARMORYRESEARCH_TERRANVEHICLEANDSHIPPLATINGLEVEL3],
                                 Api::UnitTypeId::FUSIONCORE =>
  [Api::AbilityId::RESEARCH_BATTLECRUISERWEAPONREFIT,
    Api::AbilityId::FUSIONCORERESEARCH_RESEARCHBALLISTICRANGE,
    Api::AbilityId::FUSIONCORERESEARCH_RESEARCHMEDIVACENERGYUPGRADE],
                                 Api::UnitTypeId::AUTOTURRET =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::SIEGETANKSIEGED =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::UNSIEGE_UNSIEGE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::SIEGETANK =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SIEGEMODE_SIEGEMODE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::VIKINGASSAULT =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::MORPH_VIKINGFIGHTERMODE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::VIKINGFIGHTER =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::MORPH_VIKINGASSAULTMODE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::COMMANDCENTERFLYING =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::LOADALL_COMMANDCENTER,
    Api::AbilityId::LAND_COMMANDCENTER,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::BARRACKSTECHLAB =>
  [Api::AbilityId::BARRACKSTECHLABRESEARCH_STIMPACK,
    Api::AbilityId::RESEARCH_COMBATSHIELD,
    Api::AbilityId::RESEARCH_CONCUSSIVESHELLS],
                                 Api::UnitTypeId::BARRACKSREACTOR => [],
                                 Api::UnitTypeId::FACTORYTECHLAB =>
  [Api::AbilityId::RESEARCH_INFERNALPREIGNITER,
    Api::AbilityId::FACTORYTECHLABRESEARCH_CYCLONERESEARCHHURRICANETHRUSTERS,
    Api::AbilityId::RESEARCH_DRILLINGCLAWS,
    Api::AbilityId::RESEARCH_SMARTSERVOS],
                                 Api::UnitTypeId::FACTORYREACTOR => [],
                                 Api::UnitTypeId::STARPORTTECHLAB =>
  [Api::AbilityId::RESEARCH_BANSHEECLOAKINGFIELD,
    Api::AbilityId::RESEARCH_BANSHEEHYPERFLIGHTROTORS,
    Api::AbilityId::STARPORTTECHLABRESEARCH_RESEARCHRAVENINTERFERENCEMATRIX],
                                 Api::UnitTypeId::STARPORTREACTOR => [],
                                 Api::UnitTypeId::FACTORYFLYING =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::BUILD_TECHLAB_FACTORY,
    Api::AbilityId::BUILD_REACTOR_FACTORY,
    Api::AbilityId::LAND_FACTORY,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::STARPORTFLYING =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::BUILD_TECHLAB_STARPORT,
    Api::AbilityId::BUILD_REACTOR_STARPORT,
    Api::AbilityId::LAND_STARPORT,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::SCV =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::EFFECT_SPRAY_TERRAN,
    Api::AbilityId::HARVEST_GATHER_SCV,
    Api::AbilityId::EFFECT_REPAIR_SCV,
    Api::AbilityId::TERRANBUILD_COMMANDCENTER,
    Api::AbilityId::TERRANBUILD_SUPPLYDEPOT,
    Api::AbilityId::TERRANBUILD_REFINERY,
    Api::AbilityId::SMART,
    Api::AbilityId::TERRANBUILD_BARRACKS,
    Api::AbilityId::TERRANBUILD_ENGINEERINGBAY,
    Api::AbilityId::TERRANBUILD_MISSILETURRET,
    Api::AbilityId::TERRANBUILD_BUNKER,
    Api::AbilityId::TERRANBUILD_SENSORTOWER,
    Api::AbilityId::TERRANBUILD_GHOSTACADEMY,
    Api::AbilityId::TERRANBUILD_FACTORY,
    Api::AbilityId::TERRANBUILD_STARPORT,
    Api::AbilityId::TERRANBUILD_ARMORY,
    Api::AbilityId::TERRANBUILD_FUSIONCORE],
                                 Api::UnitTypeId::BARRACKSFLYING =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::BUILD_TECHLAB_BARRACKS,
    Api::AbilityId::BUILD_REACTOR_BARRACKS,
    Api::AbilityId::LAND_BARRACKS,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::SUPPLYDEPOTLOWERED =>
  [Api::AbilityId::MORPH_SUPPLYDEPOT_RAISE],
                                 Api::UnitTypeId::MARINE =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART,
    Api::AbilityId::EFFECT_STIM_MARINE],
                                 Api::UnitTypeId::REAPER =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::KD8CHARGE_KD8CHARGE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::GHOST =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::BEHAVIOR_HOLDFIREON_GHOST,
    Api::AbilityId::EMP_EMP,
    Api::AbilityId::EFFECT_GHOSTSNIPE,
    Api::AbilityId::SMART,
    Api::AbilityId::BEHAVIOR_CLOAKON_GHOST],
                                 Api::UnitTypeId::MARAUDER =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART,
    Api::AbilityId::EFFECT_STIM_MARAUDER],
                                 Api::UnitTypeId::THOR =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::MORPH_THORHIGHIMPACTMODE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::HELLION =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART,
    Api::AbilityId::MORPH_HELLBAT],
                                 Api::UnitTypeId::MEDIVAC =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::MEDIVACHEAL_HEAL,
    Api::AbilityId::LOAD_MEDIVAC,
    Api::AbilityId::EFFECT_MEDIVACIGNITEAFTERBURNERS,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::BANSHEE =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART,
    Api::AbilityId::BEHAVIOR_CLOAKON_BANSHEE],
                                 Api::UnitTypeId::RAVEN =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::BUILDAUTOTURRET_AUTOTURRET,
    Api::AbilityId::EFFECT_ANTIARMORMISSILE,
    Api::AbilityId::SMART,
    Api::AbilityId::EFFECT_INTERFERENCEMATRIX],
                                 Api::UnitTypeId::BATTLECRUISER =>
  [Api::AbilityId::EFFECT_TACTICALJUMP,
    Api::AbilityId::ATTACK_BATTLECRUISER,
    Api::AbilityId::MOVE_BATTLECRUISER,
    Api::AbilityId::PATROL_BATTLECRUISER,
    Api::AbilityId::HOLDPOSITION_BATTLECRUISER,
    Api::AbilityId::STOP_BATTLECRUISER,
    Api::AbilityId::SMART,
    Api::AbilityId::YAMATO_YAMATOGUN],
                                 Api::UnitTypeId::NUKE => [],
                                 Api::UnitTypeId::NEXUS =>
  [Api::AbilityId::RALLY_NEXUS,
    Api::AbilityId::NEXUSTRAIN_PROBE,
    Api::AbilityId::BATTERYOVERCHARGE_BATTERYOVERCHARGE,
    Api::AbilityId::EFFECT_CHRONOBOOSTENERGYCOST,
    Api::AbilityId::EFFECT_MASSRECALL_NEXUS,
    Api::AbilityId::SMART,
    Api::AbilityId::NEXUSTRAINMOTHERSHIP_MOTHERSHIP],
                                 Api::UnitTypeId::PYLON => [],
                                 Api::UnitTypeId::ASSIMILATOR => [],
                                 Api::UnitTypeId::GATEWAY =>
  [Api::AbilityId::RALLY_BUILDING,
    Api::AbilityId::GATEWAYTRAIN_ZEALOT,
    Api::AbilityId::SMART,
    Api::AbilityId::GATEWAYTRAIN_STALKER,
    Api::AbilityId::GATEWAYTRAIN_HIGHTEMPLAR,
    Api::AbilityId::GATEWAYTRAIN_DARKTEMPLAR,
    Api::AbilityId::GATEWAYTRAIN_SENTRY,
    Api::AbilityId::TRAIN_ADEPT,
    Api::AbilityId::MORPH_WARPGATE],
                                 Api::UnitTypeId::FORGE =>
  [Api::AbilityId::FORGERESEARCH_PROTOSSGROUNDWEAPONSLEVEL1,
    Api::AbilityId::FORGERESEARCH_PROTOSSGROUNDARMORLEVEL1,
    Api::AbilityId::FORGERESEARCH_PROTOSSSHIELDSLEVEL1,
    Api::AbilityId::FORGERESEARCH_PROTOSSGROUNDWEAPONSLEVEL2,
    Api::AbilityId::FORGERESEARCH_PROTOSSGROUNDWEAPONSLEVEL3,
    Api::AbilityId::FORGERESEARCH_PROTOSSGROUNDARMORLEVEL2,
    Api::AbilityId::FORGERESEARCH_PROTOSSGROUNDARMORLEVEL3,
    Api::AbilityId::FORGERESEARCH_PROTOSSSHIELDSLEVEL2,
    Api::AbilityId::FORGERESEARCH_PROTOSSSHIELDSLEVEL3],
                                 Api::UnitTypeId::FLEETBEACON =>
  [Api::AbilityId::RESEARCH_PHOENIXANIONPULSECRYSTALS,
    Api::AbilityId::FLEETBEACONRESEARCH_RESEARCHVOIDRAYSPEEDUPGRADE,
    Api::AbilityId::FLEETBEACONRESEARCH_TEMPESTRESEARCHGROUNDATTACKUPGRADE],
                                 Api::UnitTypeId::TWILIGHTCOUNCIL =>
  [Api::AbilityId::RESEARCH_CHARGE,
    Api::AbilityId::RESEARCH_BLINK,
    Api::AbilityId::RESEARCH_ADEPTRESONATINGGLAIVES],
                                 Api::UnitTypeId::PHOTONCANNON =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::STARGATE =>
  [Api::AbilityId::RALLY_BUILDING,
    Api::AbilityId::STARGATETRAIN_PHOENIX,
    Api::AbilityId::STARGATETRAIN_VOIDRAY,
    Api::AbilityId::STARGATETRAIN_ORACLE,
    Api::AbilityId::SMART,
    Api::AbilityId::STARGATETRAIN_CARRIER,
    Api::AbilityId::STARGATETRAIN_TEMPEST],
                                 Api::UnitTypeId::TEMPLARARCHIVE => [Api::AbilityId::RESEARCH_PSISTORM],
                                 Api::UnitTypeId::DARKSHRINE => [Api::AbilityId::RESEARCH_SHADOWSTRIKE],
                                 Api::UnitTypeId::ROBOTICSBAY =>
  [Api::AbilityId::RESEARCH_GRAVITICBOOSTER,
    Api::AbilityId::RESEARCH_GRAVITICDRIVE,
    Api::AbilityId::RESEARCH_EXTENDEDTHERMALLANCE],
                                 Api::UnitTypeId::ROBOTICSFACILITY =>
  [Api::AbilityId::RALLY_BUILDING,
    Api::AbilityId::ROBOTICSFACILITYTRAIN_WARPPRISM,
    Api::AbilityId::ROBOTICSFACILITYTRAIN_OBSERVER,
    Api::AbilityId::ROBOTICSFACILITYTRAIN_IMMORTAL,
    Api::AbilityId::SMART,
    Api::AbilityId::ROBOTICSFACILITYTRAIN_COLOSSUS,
    Api::AbilityId::TRAIN_DISRUPTOR],
                                 Api::UnitTypeId::CYBERNETICSCORE =>
  [Api::AbilityId::CYBERNETICSCORERESEARCH_PROTOSSAIRWEAPONSLEVEL1,
    Api::AbilityId::CYBERNETICSCORERESEARCH_PROTOSSAIRARMORLEVEL1,
    Api::AbilityId::RESEARCH_WARPGATE,
    Api::AbilityId::CYBERNETICSCORERESEARCH_PROTOSSAIRWEAPONSLEVEL2,
    Api::AbilityId::CYBERNETICSCORERESEARCH_PROTOSSAIRWEAPONSLEVEL3,
    Api::AbilityId::CYBERNETICSCORERESEARCH_PROTOSSAIRARMORLEVEL2,
    Api::AbilityId::CYBERNETICSCORERESEARCH_PROTOSSAIRARMORLEVEL3],
                                 Api::UnitTypeId::ZEALOT =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART,
    Api::AbilityId::EFFECT_CHARGE],
                                 Api::UnitTypeId::STALKER =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART,
    Api::AbilityId::EFFECT_BLINK_STALKER],
                                 Api::UnitTypeId::HIGHTEMPLAR =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::FEEDBACK_FEEDBACK,
    Api::AbilityId::SMART,
    Api::AbilityId::PSISTORM_PSISTORM,
    Api::AbilityId::MORPH_ARCHON],
                                 Api::UnitTypeId::DARKTEMPLAR =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART,
    Api::AbilityId::EFFECT_SHADOWSTRIDE,
    Api::AbilityId::MORPH_ARCHON],
                                 Api::UnitTypeId::SENTRY =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::GUARDIANSHIELD_GUARDIANSHIELD,
    Api::AbilityId::HALLUCINATION_ARCHON,
    Api::AbilityId::HALLUCINATION_COLOSSUS,
    Api::AbilityId::HALLUCINATION_HIGHTEMPLAR,
    Api::AbilityId::HALLUCINATION_IMMORTAL,
    Api::AbilityId::HALLUCINATION_PHOENIX,
    Api::AbilityId::HALLUCINATION_PROBE,
    Api::AbilityId::HALLUCINATION_STALKER,
    Api::AbilityId::HALLUCINATION_VOIDRAY,
    Api::AbilityId::HALLUCINATION_WARPPRISM,
    Api::AbilityId::HALLUCINATION_ZEALOT,
    Api::AbilityId::FORCEFIELD_FORCEFIELD,
    Api::AbilityId::HALLUCINATION_ORACLE,
    Api::AbilityId::HALLUCINATION_DISRUPTOR,
    Api::AbilityId::HALLUCINATION_ADEPT,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::PHOENIX =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::GRAVITONBEAM_GRAVITONBEAM,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::CARRIER =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::CANCEL_HANGARQUEUE5,
    Api::AbilityId::BUILD_INTERCEPTORS,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::VOIDRAY =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::EFFECT_VOIDRAYPRISMATICALIGNMENT,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::WARPPRISM =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::LOAD_WARPPRISM,
    Api::AbilityId::MORPH_WARPPRISMPHASINGMODE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::OBSERVER =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::MORPH_SURVEILLANCEMODE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::IMMORTAL =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::PROBE =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::EFFECT_SPRAY_PROTOSS,
    Api::AbilityId::HARVEST_GATHER_PROBE,
    Api::AbilityId::PROTOSSBUILD_NEXUS,
    Api::AbilityId::PROTOSSBUILD_PYLON,
    Api::AbilityId::PROTOSSBUILD_ASSIMILATOR,
    Api::AbilityId::SMART,
    Api::AbilityId::PROTOSSBUILD_GATEWAY,
    Api::AbilityId::PROTOSSBUILD_FORGE,
    Api::AbilityId::PROTOSSBUILD_FLEETBEACON,
    Api::AbilityId::PROTOSSBUILD_TWILIGHTCOUNCIL,
    Api::AbilityId::PROTOSSBUILD_PHOTONCANNON,
    Api::AbilityId::PROTOSSBUILD_STARGATE,
    Api::AbilityId::PROTOSSBUILD_TEMPLARARCHIVE,
    Api::AbilityId::PROTOSSBUILD_DARKSHRINE,
    Api::AbilityId::PROTOSSBUILD_ROBOTICSBAY,
    Api::AbilityId::PROTOSSBUILD_ROBOTICSFACILITY,
    Api::AbilityId::PROTOSSBUILD_CYBERNETICSCORE,
    Api::AbilityId::BUILD_SHIELDBATTERY],
                                 Api::UnitTypeId::INTERCEPTOR =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::HATCHERY =>
  [Api::AbilityId::RALLY_HATCHERY_UNITS,
    Api::AbilityId::RALLY_HATCHERY_WORKERS,
    Api::AbilityId::RESEARCH_PNEUMATIZEDCARAPACE,
    Api::AbilityId::RESEARCH_BURROW,
    Api::AbilityId::SMART,
    Api::AbilityId::UPGRADETOLAIR_LAIR,
    Api::AbilityId::TRAINQUEEN_QUEEN],
                                 Api::UnitTypeId::CREEPTUMOR => [],
                                 Api::UnitTypeId::EXTRACTOR => [],
                                 Api::UnitTypeId::SPAWNINGPOOL =>
  [Api::AbilityId::RESEARCH_ZERGLINGMETABOLICBOOST,
    Api::AbilityId::RESEARCH_ZERGLINGADRENALGLANDS],
                                 Api::UnitTypeId::EVOLUTIONCHAMBER =>
  [Api::AbilityId::RESEARCH_ZERGMELEEWEAPONSLEVEL1,
    Api::AbilityId::RESEARCH_ZERGGROUNDARMORLEVEL1,
    Api::AbilityId::RESEARCH_ZERGMISSILEWEAPONSLEVEL1,
    Api::AbilityId::RESEARCH_ZERGMELEEWEAPONSLEVEL2,
    Api::AbilityId::RESEARCH_ZERGMELEEWEAPONSLEVEL3,
    Api::AbilityId::RESEARCH_ZERGGROUNDARMORLEVEL2,
    Api::AbilityId::RESEARCH_ZERGGROUNDARMORLEVEL3,
    Api::AbilityId::RESEARCH_ZERGMISSILEWEAPONSLEVEL2,
    Api::AbilityId::RESEARCH_ZERGMISSILEWEAPONSLEVEL3],
                                 Api::UnitTypeId::HYDRALISKDEN =>
  [Api::AbilityId::RESEARCH_GROOVEDSPINES,
    Api::AbilityId::RESEARCH_MUSCULARAUGMENTS],
                                 Api::UnitTypeId::SPIRE =>
  [Api::AbilityId::RESEARCH_ZERGFLYERATTACKLEVEL1,
    Api::AbilityId::RESEARCH_ZERGFLYERARMORLEVEL1,
    Api::AbilityId::UPGRADETOGREATERSPIRE_GREATERSPIRE,
    Api::AbilityId::RESEARCH_ZERGFLYERATTACKLEVEL2,
    Api::AbilityId::RESEARCH_ZERGFLYERATTACKLEVEL3,
    Api::AbilityId::RESEARCH_ZERGFLYERARMORLEVEL2,
    Api::AbilityId::RESEARCH_ZERGFLYERARMORLEVEL3],
                                 Api::UnitTypeId::ULTRALISKCAVERN =>
  [Api::AbilityId::RESEARCH_ANABOLICSYNTHESIS,
    Api::AbilityId::RESEARCH_CHITINOUSPLATING],
                                 Api::UnitTypeId::INFESTATIONPIT =>
  [Api::AbilityId::RESEARCH_NEURALPARASITE],
                                 Api::UnitTypeId::NYDUSNETWORK =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::RALLY_BUILDING,
    Api::AbilityId::LOAD_NYDUSNETWORK,
    Api::AbilityId::BUILD_NYDUSWORM,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::BANELINGNEST =>
  [Api::AbilityId::RESEARCH_CENTRIFUGALHOOKS],
                                 Api::UnitTypeId::ROACHWARREN =>
  [Api::AbilityId::RESEARCH_GLIALREGENERATION,
    Api::AbilityId::RESEARCH_TUNNELINGCLAWS],
                                 Api::UnitTypeId::SPINECRAWLER =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SPINECRAWLERUPROOT_SPINECRAWLERUPROOT,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::SPORECRAWLER =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SPORECRAWLERUPROOT_SPORECRAWLERUPROOT,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::LAIR =>
  [Api::AbilityId::RALLY_HATCHERY_UNITS,
    Api::AbilityId::RALLY_HATCHERY_WORKERS,
    Api::AbilityId::RESEARCH_PNEUMATIZEDCARAPACE,
    Api::AbilityId::RESEARCH_BURROW,
    Api::AbilityId::SMART,
    Api::AbilityId::UPGRADETOHIVE_HIVE,
    Api::AbilityId::TRAINQUEEN_QUEEN],
                                 Api::UnitTypeId::HIVE =>
  [Api::AbilityId::RALLY_HATCHERY_UNITS,
    Api::AbilityId::RALLY_HATCHERY_WORKERS,
    Api::AbilityId::RESEARCH_PNEUMATIZEDCARAPACE,
    Api::AbilityId::RESEARCH_BURROW,
    Api::AbilityId::SMART,
    Api::AbilityId::TRAINQUEEN_QUEEN],
                                 Api::UnitTypeId::GREATERSPIRE =>
  [Api::AbilityId::RESEARCH_ZERGFLYERATTACKLEVEL1,
    Api::AbilityId::RESEARCH_ZERGFLYERARMORLEVEL1,
    Api::AbilityId::RESEARCH_ZERGFLYERATTACKLEVEL2,
    Api::AbilityId::RESEARCH_ZERGFLYERATTACKLEVEL3,
    Api::AbilityId::RESEARCH_ZERGFLYERARMORLEVEL2,
    Api::AbilityId::RESEARCH_ZERGFLYERARMORLEVEL3],
                                 Api::UnitTypeId::EGG =>
  [Api::AbilityId::RALLY_BUILDING, Api::AbilityId::SMART],
                                 Api::UnitTypeId::DRONE =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::EFFECT_SPRAY_ZERG,
    Api::AbilityId::ZERGBUILD_HATCHERY,
    Api::AbilityId::ZERGBUILD_EXTRACTOR,
    Api::AbilityId::HARVEST_GATHER_DRONE,
    Api::AbilityId::SMART,
    Api::AbilityId::ZERGBUILD_SPAWNINGPOOL,
    Api::AbilityId::ZERGBUILD_EVOLUTIONCHAMBER,
    Api::AbilityId::ZERGBUILD_HYDRALISKDEN,
    Api::AbilityId::ZERGBUILD_SPIRE,
    Api::AbilityId::ZERGBUILD_ULTRALISKCAVERN,
    Api::AbilityId::ZERGBUILD_INFESTATIONPIT,
    Api::AbilityId::ZERGBUILD_NYDUSNETWORK,
    Api::AbilityId::ZERGBUILD_BANELINGNEST,
    Api::AbilityId::BUILD_LURKERDEN,
    Api::AbilityId::ZERGBUILD_ROACHWARREN,
    Api::AbilityId::ZERGBUILD_SPINECRAWLER,
    Api::AbilityId::ZERGBUILD_SPORECRAWLER,
    Api::AbilityId::BURROWDOWN_DRONE],
                                 Api::UnitTypeId::ZERGLING =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART,
    Api::AbilityId::BURROWDOWN_ZERGLING,
    Api::AbilityId::MORPHTOBANELING_CANCEL],
                                 Api::UnitTypeId::OVERLORD =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::SMART,
    Api::AbilityId::MORPH_OVERSEER,
    Api::AbilityId::BEHAVIOR_GENERATECREEPON,
    Api::AbilityId::MORPH_OVERLORDTRANSPORT],
                                 Api::UnitTypeId::HYDRALISK =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART,
    Api::AbilityId::BURROWDOWN_HYDRALISK,
    Api::AbilityId::MORPH_LURKER],
                                 Api::UnitTypeId::MUTALISK =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::ULTRALISK =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART,
    Api::AbilityId::BURROWDOWN_ULTRALISK],
                                 Api::UnitTypeId::ROACH =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART,
    Api::AbilityId::BURROWDOWN_ROACH,
    Api::AbilityId::MORPHTORAVAGER_RAVAGER],
                                 Api::UnitTypeId::INFESTOR =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::FUNGALGROWTH_FUNGALGROWTH,
    Api::AbilityId::AMORPHOUSARMORCLOUD_AMORPHOUSARMORCLOUD,
    Api::AbilityId::SMART,
    Api::AbilityId::NEURALPARASITE_NEURALPARASITE,
    Api::AbilityId::BURROWDOWN_INFESTORTERRAN,
    Api::AbilityId::BURROWDOWN_INFESTOR],
                                 Api::UnitTypeId::CORRUPTOR =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::CAUSTICSPRAY_CAUSTICSPRAY,
    Api::AbilityId::SMART,
    Api::AbilityId::MORPHTOBROODLORD_BROODLORD],
                                 Api::UnitTypeId::BROODLORDCOCOON => [],
                                 Api::UnitTypeId::BROODLORD =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::BANELINGBURROWED =>
  [Api::AbilityId::EXPLODE_EXPLODE, Api::AbilityId::BURROWUP_BANELING],
                                 Api::UnitTypeId::DRONEBURROWED => [Api::AbilityId::BURROWUP_DRONE],
                                 Api::UnitTypeId::HYDRALISKBURROWED => [Api::AbilityId::BURROWUP_HYDRALISK],
                                 Api::UnitTypeId::ROACHBURROWED =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::BURROWUP_ROACH,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::ZERGLINGBURROWED => [Api::AbilityId::BURROWUP_ZERGLING],
                                 Api::UnitTypeId::INFESTORTERRANBURROWED =>
  [Api::AbilityId::BURROWUP_INFESTORTERRAN],
                                 Api::UnitTypeId::QUEENBURROWED => [Api::AbilityId::BURROWUP_QUEEN],
                                 Api::UnitTypeId::QUEEN =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::EFFECT_INJECTLARVA,
    Api::AbilityId::TRANSFUSION_TRANSFUSION,
    Api::AbilityId::BUILD_CREEPTUMOR_QUEEN,
    Api::AbilityId::SMART,
    Api::AbilityId::BURROWDOWN_QUEEN,
    Api::AbilityId::BUILD_CREEPTUMOR],
                                 Api::UnitTypeId::INFESTORBURROWED =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::BURROWUP_INFESTORTERRAN,
    Api::AbilityId::BURROWUP_INFESTOR,
    Api::AbilityId::SMART,
    Api::AbilityId::NEURALPARASITE_NEURALPARASITE],
                                 Api::UnitTypeId::OVERLORDCOCOON => [],
                                 Api::UnitTypeId::OVERSEER =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::SPAWNCHANGELING_SPAWNCHANGELING,
    Api::AbilityId::CONTAMINATE_CONTAMINATE,
    Api::AbilityId::MORPH_OVERSIGHTMODE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::PLANETARYFORTRESS =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::RALLY_COMMANDCENTER,
    Api::AbilityId::LOADALL_COMMANDCENTER,
    Api::AbilityId::COMMANDCENTERTRAIN_SCV,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::ULTRALISKBURROWED => [Api::AbilityId::BURROWUP_ULTRALISK],
                                 Api::UnitTypeId::ORBITALCOMMAND =>
  [Api::AbilityId::CALLDOWNMULE_CALLDOWNMULE,
    Api::AbilityId::RALLY_COMMANDCENTER,
    Api::AbilityId::SUPPLYDROP_SUPPLYDROP,
    Api::AbilityId::SCANNERSWEEP_SCAN,
    Api::AbilityId::COMMANDCENTERTRAIN_SCV,
    Api::AbilityId::LIFT_ORBITALCOMMAND,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::WARPGATE =>
  [Api::AbilityId::WARPGATETRAIN_ZEALOT,
    Api::AbilityId::MORPH_GATEWAY,
    Api::AbilityId::SMART,
    Api::AbilityId::WARPGATETRAIN_STALKER,
    Api::AbilityId::WARPGATETRAIN_HIGHTEMPLAR,
    Api::AbilityId::WARPGATETRAIN_DARKTEMPLAR,
    Api::AbilityId::WARPGATETRAIN_SENTRY,
    Api::AbilityId::TRAINWARP_ADEPT],
                                 Api::UnitTypeId::ORBITALCOMMANDFLYING =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::LAND_ORBITALCOMMAND,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::WARPPRISMPHASING =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::LOAD_WARPPRISM,
    Api::AbilityId::MORPH_WARPPRISMTRANSPORTMODE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::CREEPTUMORBURROWED =>
  [Api::AbilityId::BUILD_CREEPTUMOR_TUMOR,
    Api::AbilityId::SMART,
    Api::AbilityId::BUILD_CREEPTUMOR],
                                 Api::UnitTypeId::CREEPTUMORQUEEN =>
  [Api::AbilityId::BUILD_CREEPTUMOR_TUMOR, Api::AbilityId::SMART],
                                 Api::UnitTypeId::SPINECRAWLERUPROOTED =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::SMART,
    Api::AbilityId::SPINECRAWLERROOT_SPINECRAWLERROOT],
                                 Api::UnitTypeId::SPORECRAWLERUPROOTED =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::SMART,
    Api::AbilityId::SPORECRAWLERROOT_SPORECRAWLERROOT],
                                 Api::UnitTypeId::ARCHON =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::NYDUSCANAL =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::RALLY_BUILDING,
    Api::AbilityId::LOAD_NYDUSWORM,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::GHOSTNOVA =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::BEHAVIOR_HOLDFIREON_GHOST,
    Api::AbilityId::EMP_EMP,
    Api::AbilityId::EFFECT_GHOSTSNIPE,
    Api::AbilityId::SMART,
    Api::AbilityId::BEHAVIOR_CLOAKON_GHOST],
                                 Api::UnitTypeId::INFESTEDTERRANSEGG =>
  [Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::LARVA =>
  [Api::AbilityId::LARVATRAIN_DRONE,
    Api::AbilityId::LARVATRAIN_OVERLORD,
    Api::AbilityId::LARVATRAIN_ZERGLING,
    Api::AbilityId::LARVATRAIN_HYDRALISK,
    Api::AbilityId::LARVATRAIN_MUTALISK,
    Api::AbilityId::LARVATRAIN_ULTRALISK,
    Api::AbilityId::LARVATRAIN_ROACH,
    Api::AbilityId::LARVATRAIN_INFESTOR,
    Api::AbilityId::LARVATRAIN_CORRUPTOR,
    Api::AbilityId::LARVATRAIN_VIPER,
    Api::AbilityId::TRAIN_SWARMHOST],
                                 Api::UnitTypeId::MULE =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::EFFECT_REPAIR_MULE,
    Api::AbilityId::HARVEST_GATHER_MULE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::BROODLING =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::ADEPT =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::ADEPTPHASESHIFT_ADEPTPHASESHIFT,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::INFESTEDTERRANSEGGPLACEMENT => [],
                                 Api::UnitTypeId::HELLIONTANK =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART,
    Api::AbilityId::MORPH_HELLION],
                                 Api::UnitTypeId::MOTHERSHIPCORE =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::EFFECT_MASSRECALL_MOTHERSHIPCORE,
    Api::AbilityId::EFFECT_PHOTONOVERCHARGE,
    Api::AbilityId::EFFECT_TIMEWARP,
    Api::AbilityId::SMART,
    Api::AbilityId::MORPH_MOTHERSHIP],
                                 Api::UnitTypeId::LOCUSTMP =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::NYDUSCANALATTACKER =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::NYDUSCANALCREEPER =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::DIGESTERCREEPSPRAY_DIGESTERCREEPSPRAY,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::SWARMHOSTBURROWEDMP =>
  [Api::AbilityId::EFFECT_SPAWNLOCUSTS, Api::AbilityId::SMART],
                                 Api::UnitTypeId::SWARMHOSTMP =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::EFFECT_SPAWNLOCUSTS,
    Api::AbilityId::SMART,
    Api::AbilityId::BURROWDOWN_SWARMHOST],
                                 Api::UnitTypeId::ORACLE =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::ORACLEREVELATION_ORACLEREVELATION,
    Api::AbilityId::BEHAVIOR_PULSARBEAMON,
    Api::AbilityId::BUILD_STASISTRAP,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::TEMPEST =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::WARHOUND =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::TORNADOMISSILE_TORNADOMISSILE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::WIDOWMINE =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::BURROWDOWN_WIDOWMINE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::VIPER =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::BLINDINGCLOUD_BLINDINGCLOUD,
    Api::AbilityId::EFFECT_ABDUCT,
    Api::AbilityId::VIPERCONSUMESTRUCTURE_VIPERCONSUME,
    Api::AbilityId::PARASITICBOMB_PARASITICBOMB,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::WIDOWMINEBURROWED =>
  [Api::AbilityId::BURROWUP_WIDOWMINE,
    Api::AbilityId::WIDOWMINEATTACK_WIDOWMINEATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::LURKERMPEGG =>
  [Api::AbilityId::RALLY_BUILDING, Api::AbilityId::SMART],
                                 Api::UnitTypeId::LURKERMP =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::BURROWDOWN_LURKER,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::LURKERMPBURROWED =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::BURROWUP_LURKER,
    Api::AbilityId::BEHAVIOR_HOLDFIREON_LURKER,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::LURKERDENMP =>
  [Api::AbilityId::RESEARCH_ADAPTIVETALONS,
    Api::AbilityId::LURKERDENRESEARCH_RESEARCHLURKERRANGE],
                                 Api::UnitTypeId::RESOURCEBLOCKER => [],
                                 Api::UnitTypeId::ICEPROTOSSCRATES => [],
                                 Api::UnitTypeId::PROTOSSCRATES => [],
                                 Api::UnitTypeId::TOWERMINE => [],
                                 Api::UnitTypeId::RAVAGERCOCOON =>
  [Api::AbilityId::RALLY_BUILDING, Api::AbilityId::SMART],
                                 Api::UnitTypeId::RAVAGER =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::EFFECT_CORROSIVEBILE,
    Api::AbilityId::SMART,
    Api::AbilityId::BURROWDOWN_RAVAGER],
                                 Api::UnitTypeId::LIBERATOR =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::MORPH_LIBERATORAGMODE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::RAVAGERBURROWED => [Api::AbilityId::BURROWUP_RAVAGER],
                                 Api::UnitTypeId::THORAP =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::MORPH_THOREXPLOSIVEMODE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::CYCLONE =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::LOCKON_LOCKON,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::LOCUSTMPFLYING =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::EFFECT_LOCUSTSWOOP,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::DISRUPTOR =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::EFFECT_PURIFICATIONNOVA,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::VOIDMPIMMORTALREVIVECORPSE =>
  [Api::AbilityId::RALLY_BUILDING,
    Api::AbilityId::VOIDMPIMMORTALREVIVEREBUILD_IMMORTAL,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::GUARDIANCOCOONMP => [],
                                 Api::UnitTypeId::GUARDIANMP =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::DEVOURERCOCOONMP => [],
                                 Api::UnitTypeId::DEVOURERMP =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::DEFILERMPBURROWED =>
  [Api::AbilityId::DEFILERMPUNBURROW_BURROWUP],
                                 Api::UnitTypeId::DEFILERMP =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::DEFILERMPCONSUME_DEFILERMPCONSUME,
    Api::AbilityId::DEFILERMPDARKSWARM_DEFILERMPDARKSWARM,
    Api::AbilityId::DEFILERMPPLAGUE_DEFILERMPPLAGUE,
    Api::AbilityId::SMART,
    Api::AbilityId::DEFILERMPBURROW_BURROWDOWN],
                                 Api::UnitTypeId::ORACLESTASISTRAP => [],
                                 Api::UnitTypeId::DISRUPTORPHASED =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::LIBERATORAG =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::MORPH_LIBERATORAAMODE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::RELEASEINTERCEPTORSBEACON => [],
                                 Api::UnitTypeId::ADEPTPHASESHIFT =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::CANCEL_ADEPTSHADEPHASESHIFT,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::THORAALANCE => [],
                                 Api::UnitTypeId::HERCPLACEMENT =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::HERC =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::REPLICANT =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::CORSAIRMP =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::CORSAIRMPDISRUPTIONWEB_CORSAIRMPDISRUPTIONWEB,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::SCOUTMP =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::ARBITERMP =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::ARBITERMPSTASISFIELD_ARBITERMPSTASISFIELD,
    Api::AbilityId::ARBITERMPRECALL_ARBITERMPRECALL,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::SCOURGEMP =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::QUEENMP =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::QUEENMPENSNARE_QUEENMPENSNARE,
    Api::AbilityId::QUEENMPSPAWNBROODLINGS_QUEENMPSPAWNBROODLINGS,
    Api::AbilityId::QUEENMPINFESTCOMMANDCENTER_QUEENMPINFESTCOMMANDCENTER,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::ELSECARO_COLONIST_HUT =>
  [Api::AbilityId::RALLY_BUILDING, Api::AbilityId::SMART],
                                 Api::UnitTypeId::TRANSPORTOVERLORDCOCOON => [],
                                 Api::UnitTypeId::OVERLORDTRANSPORT =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::PATROL_PATROL,
    Api::AbilityId::HOLDPOSITION_HOLD,
    Api::AbilityId::SCAN_MOVE,
    Api::AbilityId::LOAD_OVERLORD,
    Api::AbilityId::SMART,
    Api::AbilityId::MORPH_OVERSEER,
    Api::AbilityId::BEHAVIOR_GENERATECREEPON],
                                 Api::UnitTypeId::PYLONOVERCHARGED => [],
                                 Api::UnitTypeId::BYPASSARMORDRONE =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::MOVE_MOVE,
    Api::AbilityId::ATTACK_ATTACK,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::SHIELDBATTERY =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::SHIELDBATTERYRECHARGEEX5_SHIELDBATTERYRECHARGE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::OBSERVERSIEGEMODE =>
  [Api::AbilityId::STOP_STOP, Api::AbilityId::MORPH_OBSERVERMODE],
                                 Api::UnitTypeId::OVERSEERSIEGEMODE =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::SPAWNCHANGELING_SPAWNCHANGELING,
    Api::AbilityId::CONTAMINATE_CONTAMINATE,
    Api::AbilityId::MORPH_OVERSEERMODE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::RAVENREPAIRDRONE =>
  [Api::AbilityId::STOP_STOP,
    Api::AbilityId::EFFECT_REPAIR_REPAIRDRONE,
    Api::AbilityId::SMART],
                                 Api::UnitTypeId::VIKING => [],
                                 Api::UnitTypeId::REFINERYRICH => [],
                                 Api::UnitTypeId::ASSIMILATORRICH => [],
                                 Api::UnitTypeId::EXTRACTORRICH => []}

      def unit_alias_data = {Api::UnitTypeId::CHANGELINGZEALOT => Api::UnitTypeId::CHANGELING,
                             Api::UnitTypeId::CHANGELINGMARINESHIELD => Api::UnitTypeId::CHANGELING,
                             Api::UnitTypeId::CHANGELINGMARINE => Api::UnitTypeId::CHANGELING,
                             Api::UnitTypeId::CHANGELINGZERGLINGWINGS => Api::UnitTypeId::CHANGELING,
                             Api::UnitTypeId::CHANGELINGZERGLING => Api::UnitTypeId::CHANGELING,
                             Api::UnitTypeId::SIEGETANKSIEGED => Api::UnitTypeId::SIEGETANK,
                             Api::UnitTypeId::VIKINGASSAULT => Api::UnitTypeId::VIKINGFIGHTER,
                             Api::UnitTypeId::COMMANDCENTERFLYING => Api::UnitTypeId::COMMANDCENTER,
                             Api::UnitTypeId::FACTORYFLYING => Api::UnitTypeId::FACTORY,
                             Api::UnitTypeId::STARPORTFLYING => Api::UnitTypeId::STARPORT,
                             Api::UnitTypeId::BARRACKSFLYING => Api::UnitTypeId::BARRACKS,
                             Api::UnitTypeId::SUPPLYDEPOTLOWERED => Api::UnitTypeId::SUPPLYDEPOT,
                             Api::UnitTypeId::BANELINGBURROWED => Api::UnitTypeId::BANELING,
                             Api::UnitTypeId::DRONEBURROWED => Api::UnitTypeId::DRONE,
                             Api::UnitTypeId::HYDRALISKBURROWED => Api::UnitTypeId::HYDRALISK,
                             Api::UnitTypeId::ROACHBURROWED => Api::UnitTypeId::ROACH,
                             Api::UnitTypeId::ZERGLINGBURROWED => Api::UnitTypeId::ZERGLING,
                             Api::UnitTypeId::INFESTORTERRANBURROWED => Api::UnitTypeId::INFESTORTERRAN,
                             Api::UnitTypeId::QUEENBURROWED => Api::UnitTypeId::QUEEN,
                             Api::UnitTypeId::INFESTORBURROWED => Api::UnitTypeId::INFESTOR,
                             Api::UnitTypeId::ULTRALISKBURROWED => Api::UnitTypeId::ULTRALISK,
                             Api::UnitTypeId::ORBITALCOMMANDFLYING => Api::UnitTypeId::ORBITALCOMMAND,
                             Api::UnitTypeId::WARPPRISMPHASING => Api::UnitTypeId::WARPPRISM,
                             Api::UnitTypeId::CREEPTUMORBURROWED => Api::UnitTypeId::CREEPTUMOR,
                             Api::UnitTypeId::CREEPTUMORQUEEN => Api::UnitTypeId::CREEPTUMOR,
                             Api::UnitTypeId::SPINECRAWLERUPROOTED => Api::UnitTypeId::SPINECRAWLER,
                             Api::UnitTypeId::SPORECRAWLERUPROOTED => Api::UnitTypeId::SPORECRAWLER,
                             Api::UnitTypeId::GHOSTNOVA => Api::UnitTypeId::GHOST,
                             Api::UnitTypeId::SWARMHOSTBURROWEDMP => Api::UnitTypeId::SWARMHOSTMP,
                             Api::UnitTypeId::WIDOWMINEBURROWED => Api::UnitTypeId::WIDOWMINE,
                             Api::UnitTypeId::LURKERMPBURROWED => Api::UnitTypeId::LURKERMP,
                             Api::UnitTypeId::RAVAGERBURROWED => Api::UnitTypeId::RAVAGER,
                             Api::UnitTypeId::THORAP => Api::UnitTypeId::THOR,
                             Api::UnitTypeId::LOCUSTMPFLYING => Api::UnitTypeId::LOCUSTMP,
                             Api::UnitTypeId::LIBERATORAG => Api::UnitTypeId::LIBERATOR,
                             Api::UnitTypeId::ADEPTPHASESHIFT => Api::UnitTypeId::ADEPT,
                             Api::UnitTypeId::HERCPLACEMENT => Api::UnitTypeId::HERC,
                             Api::UnitTypeId::PYLONOVERCHARGED => Api::UnitTypeId::PYLON,
                             Api::UnitTypeId::OBSERVERSIEGEMODE => Api::UnitTypeId::OBSERVER,
                             Api::UnitTypeId::OVERSEERSIEGEMODE => Api::UnitTypeId::OVERSEER}

      def unit_tech_alias_data = {Api::UnitTypeId::SIEGETANKSIEGED => [Api::UnitTypeId::SIEGETANK],
                                  Api::UnitTypeId::VIKINGASSAULT => [Api::UnitTypeId::VIKING],
                                  Api::UnitTypeId::VIKINGFIGHTER => [Api::UnitTypeId::VIKING],
                                  Api::UnitTypeId::COMMANDCENTERFLYING => [Api::UnitTypeId::COMMANDCENTER],
                                  Api::UnitTypeId::BARRACKSTECHLAB => [Api::UnitTypeId::TECHLAB],
                                  Api::UnitTypeId::BARRACKSREACTOR => [Api::UnitTypeId::REACTOR],
                                  Api::UnitTypeId::FACTORYTECHLAB => [Api::UnitTypeId::TECHLAB],
                                  Api::UnitTypeId::FACTORYREACTOR => [Api::UnitTypeId::REACTOR],
                                  Api::UnitTypeId::STARPORTTECHLAB => [Api::UnitTypeId::TECHLAB],
                                  Api::UnitTypeId::STARPORTREACTOR => [Api::UnitTypeId::REACTOR],
                                  Api::UnitTypeId::FACTORYFLYING => [Api::UnitTypeId::FACTORY],
                                  Api::UnitTypeId::STARPORTFLYING => [Api::UnitTypeId::STARPORT],
                                  Api::UnitTypeId::BARRACKSFLYING => [Api::UnitTypeId::BARRACKS],
                                  Api::UnitTypeId::SUPPLYDEPOTLOWERED => [Api::UnitTypeId::SUPPLYDEPOT],
                                  Api::UnitTypeId::LAIR => [Api::UnitTypeId::HATCHERY],
                                  Api::UnitTypeId::HIVE =>
  [Api::UnitTypeId::HATCHERY, Api::UnitTypeId::LAIR],
                                  Api::UnitTypeId::GREATERSPIRE => [Api::UnitTypeId::SPIRE],
                                  Api::UnitTypeId::QUEENBURROWED => [Api::UnitTypeId::QUEEN],
                                  Api::UnitTypeId::OVERSEER => [Api::UnitTypeId::OVERLORD],
                                  Api::UnitTypeId::PLANETARYFORTRESS => [Api::UnitTypeId::COMMANDCENTER],
                                  Api::UnitTypeId::ORBITALCOMMAND => [Api::UnitTypeId::COMMANDCENTER],
                                  Api::UnitTypeId::WARPGATE => [Api::UnitTypeId::GATEWAY],
                                  Api::UnitTypeId::ORBITALCOMMANDFLYING => [Api::UnitTypeId::COMMANDCENTER],
                                  Api::UnitTypeId::WARPPRISMPHASING => [Api::UnitTypeId::WARPPRISM],
                                  Api::UnitTypeId::CREEPTUMORBURROWED => [Api::UnitTypeId::CREEPTUMOR],
                                  Api::UnitTypeId::CREEPTUMORQUEEN => [Api::UnitTypeId::CREEPTUMOR],
                                  Api::UnitTypeId::WIDOWMINEBURROWED => [Api::UnitTypeId::WIDOWMINE],
                                  Api::UnitTypeId::THORAP => [Api::UnitTypeId::THOR],
                                  Api::UnitTypeId::LIBERATORAG => [Api::UnitTypeId::LIBERATOR],
                                  Api::UnitTypeId::OVERLORDTRANSPORT => [Api::UnitTypeId::OVERLORD],
                                  Api::UnitTypeId::PYLONOVERCHARGED =>
  [Api::UnitTypeId::PYLON, Api::UnitTypeId::PYLON],
                                  Api::UnitTypeId::OVERSEERSIEGEMODE => [Api::UnitTypeId::OVERLORD]}
    end
  end
end
