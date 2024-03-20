# Changelog

## [0.0.4](https://github.com/dysonreturns/sc2ai/compare/v0.0.4...v0.0.4) (2024-03-20)


### Miscellaneous Chores

* release 0.0.4 ([d54acf4](https://github.com/dysonreturns/sc2ai/commit/d54acf4eec47787e11741c27379412e6d53cb81d))

## [0.0.4](https://github.com/dysonreturns/sc2ai/compare/v0.0.3...v0.0.4) (2024-03-20)


### Features

* add unit# in_progress to help UG filter shorthand ([e7246c1](https://github.com/dysonreturns/sc2ai/commit/e7246c192239ff9862b7d8211822e13d38cdb79d))
* add unit#build_reactor and unit#tech_lab's queue_command variables, incase they need to land and then build. ([e5d6e95](https://github.com/dysonreturns/sc2ai/commit/e5d6e955adb9756c1e017bf1121492e471253088))
* added rbs signature gen with `rake gensig` task. ([a5a36d8](https://github.com/dysonreturns/sc2ai/commit/a5a36d858b7b0a7716b45b654fb11c97ab0cd60f))
* adding eql? for Api::Point for 3d ([77bceb0](https://github.com/dysonreturns/sc2ai/commit/77bceb09f6045d7efd0d92b22bd834048f93d60a))
* adding ug #find and #detect with forced sigs ([465183a](https://github.com/dysonreturns/sc2ai/commit/465183a7d3e5de64a048546ee4654e39798c08eb))
* adds geo.geysers_for_base and geo.minerals_for_base ([afb0e5e](https://github.com/dysonreturns/sc2ai/commit/afb0e5e5ba748d61a40b5834089ada0cea30cbb8))
* adds two debug text methods ([9285534](https://github.com/dysonreturns/sc2ai/commit/928553408b1236d5027394e115a96a94261d1e50))
* changing geo#mineral_for_base to only return alive units and adding geo#gas_for_base ([9bb14d2](https://github.com/dysonreturns/sc2ai/commit/9bb14d290996e135cf182544b1e7fc6baffd79de))
* geo helpers enemy_start_position start_position ([116f29d](https://github.com/dysonreturns/sc2ai/commit/116f29dcd5e32bbd4010240ce797d2c8caef0b8f))
* modernize gem + lint ([3ad0d9a](https://github.com/dysonreturns/sc2ai/commit/3ad0d9ad40133e222be445abb8ae5f541f5c2b54))
* more action commands: move, stop, hold ([439ea30](https://github.com/dysonreturns/sc2ai/commit/439ea3022dc88e919b6119ea39eae0677bd65186))


### Bug Fixes

* Api::Point[x,y,z] new shorthand fixed. ([9285534](https://github.com/dysonreturns/sc2ai/commit/928553408b1236d5027394e115a96a94261d1e50))
* debug_draw_box elevation even higher to prevent floor clipping ([9285534](https://github.com/dysonreturns/sc2ai/commit/928553408b1236d5027394e115a96a94261d1e50))
* find and detect to return unit instead of tag-unit tupple ([b1a2e8b](https://github.com/dysonreturns/sc2ai/commit/b1a2e8b8c7ee9cc2ffc25b7e46159ce10c14658c))
* step_count hard locked to 1 ([775518f](https://github.com/dysonreturns/sc2ai/commit/775518fda13b7fed1cbd17977ab384a319cd2064))
* step_count is api-correct name for step_size ([775518f](https://github.com/dysonreturns/sc2ai/commit/775518fda13b7fed1cbd17977ab384a319cd2064))
* suffix ? to boolean unit checks has_tech_lab? and has_reactor? ([12c47ed](https://github.com/dysonreturns/sc2ai/commit/12c47ed93a3b16d90e80dbf0fd4bc28e7ee219ce))
* terran build_reactor and build_tech_lab shortcuts doesn't accept generic abilities ([195a620](https://github.com/dysonreturns/sc2ai/commit/195a620ad5c071bb225ef78216840d634f6ebeb3))


### Miscellaneous Chores

* release 0.0.4 ([8612452](https://github.com/dysonreturns/sc2ai/commit/86124529e8782db0f60868f00a038ebdd39b237a))

## [0.0.3](https://github.com/dysonreturns/sc2ai/compare/v0.0.2...v0.0.3) (2024-02-09)


### Features

* update stableid to match v5.0.12 ([fcf4b65](https://github.com/dysonreturns/sc2ai/commit/fcf4b654e6074cccb3044e13992a02227a6ffd51))


### Bug Fixes

* .ladderignore not respected during ladderzip build ([14d38b7](https://github.com/dysonreturns/sc2ai/commit/14d38b731cf3f57ff17b70b6f400a1dc776e2b31))
* geo.powered? checks correct minimap tiles ([25cf110](https://github.com/dysonreturns/sc2ai/commit/25cf1103d66fc4ddad972e23aa2bc39c1ba63e7e))
* windows compatible ladder zip ([dfc3292](https://github.com/dysonreturns/sc2ai/commit/dfc3292f74af5fc597eb4ea5b0689d3625d5e597))


### Miscellaneous Chores

* release 0.0.3 ([0d76afa](https://github.com/dysonreturns/sc2ai/commit/0d76afa50c23eebf7f4b9237b7435ebf9303240c))

## [0.0.2](https://github.com/dysonreturns/sc2ai/compare/v0.0.1...v0.0.2) (2024-02-07)


### Bug Fixes

* ladder live check and reduce ladderzip time by pre-installing sc2ai ([3726198](https://github.com/dysonreturns/sc2ai/commit/3726198c95fbe4774865b583cd404a2645cbe305))

## [0.0.1](https://github.com/dysonreturns/sc2ai/compare/v0.0.0-pre...v0.0.1) (2024-02-07)


### Features

* Adding templates for sc2ai new and sc2ai ladderzip ([4ca8c2b](https://github.com/dysonreturns/sc2ai/commit/4ca8c2b852955c534810dd567439e6e3091b8998))
* broadly, allows `sc2ai new` and `sc2ai ladderzip` ([4ca8c2b](https://github.com/dysonreturns/sc2ai/commit/4ca8c2b852955c534810dd567439e6e3091b8998))
* drop external dependencies ([ef6018c](https://github.com/dysonreturns/sc2ai/commit/ef6018cdf7f53a7bef557d5107aa80816093c7eb))
* during init callback to Bot#configure to define additional attributes ([4ca8c2b](https://github.com/dysonreturns/sc2ai/commit/4ca8c2b852955c534810dd567439e6e3091b8998))
* enable_feature_layer configuration added ([410758b](https://github.com/dysonreturns/sc2ai/commit/410758b44a79d3b6f4138049ba04161c9c28b1b5))
* enable_feature_layer/interface_options removed from join_game and added as attributes ([4ca8c2b](https://github.com/dysonreturns/sc2ai/commit/4ca8c2b852955c534810dd567439e6e3091b8998))
* everything added ([2713e90](https://github.com/dysonreturns/sc2ai/commit/2713e90b6690a9ab0963aaff3d86563198b746b4))
* moved /data/replays to ./replays/ ([4ca8c2b](https://github.com/dysonreturns/sc2ai/commit/4ca8c2b852955c534810dd567439e6e3091b8998))
* Paths#template_root for template sources ([4ca8c2b](https://github.com/dysonreturns/sc2ai/commit/4ca8c2b852955c534810dd567439e6e3091b8998))
* reduce ladderzip builder image size to barebones 200mb. ([0b87c7a](https://github.com/dysonreturns/sc2ai/commit/0b87c7a572137ba041f244ff4c3a80a42567aa89))
* removed enable_feature_layer from Sc2 config, and forcing it via Bot#configure ([4ca8c2b](https://github.com/dysonreturns/sc2ai/commit/4ca8c2b852955c534810dd567439e6e3091b8998))
* Sc2#is_live? reads bin/ladder env "AIARENA" to toggle live or not ([4ca8c2b](https://github.com/dysonreturns/sc2ai/commit/4ca8c2b852955c534810dd567439e6e3091b8998))


### Bug Fixes

* platform specific gem includes ([4465299](https://github.com/dysonreturns/sc2ai/commit/446529918abc4862c0ee693bfe0ff91198c9f42f))
* silence warnings ([5a4b4ab](https://github.com/dysonreturns/sc2ai/commit/5a4b4ab8a7743ad80fd1f476bbbba2519d55baf6))


### Miscellaneous Chores

* release 0.0.0.pre ([3c86d6b](https://github.com/dysonreturns/sc2ai/commit/3c86d6b5a4b16682188096db50aa9dbc6a4b92ba))
* release 0.0.1 ([b2af1ba](https://github.com/dysonreturns/sc2ai/commit/b2af1ba399f8f1a3c49386a1f4f397eeafd4889d))

## 0.0.0 (2024-01-11)
