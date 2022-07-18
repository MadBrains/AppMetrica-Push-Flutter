.PHONY: version doctor

PANA_SCRIPT=../../tool/verify_pub_score.sh 100

PI_PATH= packages/appmetrica_push_platform_interface
IOS_PATH= packages/appmetrica_push_ios
ANDROID_PATH= packages/appmetrica_push_android
HUAWEI_PATH= packages/appmetrica_push_huawei
APPMETRICA_PATH= packages/appmetrica_push
EXAMPLE_FCM_PATH= examples/example_fcm
EXAMPLE_HMS_PATH= examples/example_hms

FVM = fvm
FVM_FLUTTER = $(FVM) flutter
FVM_DART = $(FVM) dart


init:
	$(FVM) use 3.0.1 --force; $(FVM_DART) pub global activate pana;

version:
	$(FVM_FLUTTER) --version; $(FVM_DART) --version;

doctor:
	$(FVM_FLUTTER) doctor;

ifeq (bump, $(firstword $(MAKECMDGOALS)))
  runargs := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
  $(eval $(runargs):;@true)
endif
bump:
	./tool/bump-version.sh $(filter-out $@,$(MAKECMDGOALS))

pub_get: pub_get_pi pub_get_ios pub_get_android pub_get_huawei pub_get_appmetrica pub_get_example_fcm pub_get_example_hms

pub_get_pi: 
	cd $(PI_PATH); $(FVM_FLUTTER) packages get;

pub_get_ios: 
	cd $(IOS_PATH); $(FVM_FLUTTER) packages get;

pub_get_android: 
	cd $(ANDROID_PATH); $(FVM_FLUTTER) packages get;

pub_get_huawei: 
	cd $(HUAWEI_PATH); $(FVM_FLUTTER) packages get;

pub_get_appmetrica: 
	cd $(APPMETRICA_PATH); $(FVM_FLUTTER) packages get;

pub_get_example_fcm: 
	cd $(EXAMPLE_FCM_PATH); $(FVM_FLUTTER) packages get;
	
pub_get_example_hms: 
	cd $(EXAMPLE_HMS_PATH); $(FVM_FLUTTER) packages get;

clean: clean_pi clean_ios clean_android clean_huawei clean_appmetrica clean_example_fcm clean_example_hms

clean_pi:
	cd $(PI_PATH); $(FVM_FLUTTER) clean;

clean_ios:
	cd $(IOS_PATH); $(FVM_FLUTTER) clean;

clean_android:
	cd $(ANDROID_PATH); $(FVM_FLUTTER) clean;

clean_huawei:
	cd $(HUAWEI_PATH); $(FVM_FLUTTER) clean;

clean_appmetrica:
	cd $(APPMETRICA_PATH); $(FVM_FLUTTER) clean;

clean_example_fcm:
	cd $(EXAMPLE_FCM_PATH); $(FVM_FLUTTER) clean;

clean_example_hms:
	cd $(EXAMPLE_HMS_PATH); $(FVM_FLUTTER) clean;

fix: fix_pi fix_ios fix_android fix_huawei fix_appmetrica fix_example_fcm fix_example_hms

fix_pi:
	cd $(PI_PATH); $(FVM_FLUTTER) format .;

fix_ios:
	cd $(IOS_PATH); $(FVM_FLUTTER) format .;

fix_android:
	cd $(ANDROID_PATH); $(FVM_FLUTTER) format .;

fix_huawei:
	cd $(HUAWEI_PATH); $(FVM_FLUTTER) format .;

fix_appmetrica:
	cd $(APPMETRICA_PATH); $(FVM_FLUTTER) format .;

fix_example_fcm:
	cd $(EXAMPLE_FCM_PATH); $(FVM_FLUTTER) format .;

fix_example_hms:
	cd $(EXAMPLE_HMS_PATH); $(FVM_FLUTTER) format .;

analyze: analyze_pi analyze_ios analyze_android analyze_huawei analyze_appmetrica analyze_example_fcm analyze_example_hms

analyze_pi:
	cd $(PI_PATH); $(FVM_FLUTTER) analyze . --fatal-infos;

analyze_ios:
	cd $(IOS_PATH); $(FVM_FLUTTER) analyze . --fatal-infos;

analyze_android:
	cd $(ANDROID_PATH); $(FVM_FLUTTER) analyze . --fatal-infos;

analyze_huawei:
	cd $(HUAWEI_PATH); $(FVM_FLUTTER) analyze . --fatal-infos;

analyze_appmetrica:
	cd $(APPMETRICA_PATH); $(FVM_FLUTTER) analyze . --fatal-infos;

analyze_example_fcm:
	cd $(EXAMPLE_FCM_PATH); $(FVM_FLUTTER) analyze . --fatal-infos;

analyze_example_hms:
	cd $(EXAMPLE_HMS_PATH); $(FVM_FLUTTER) analyze . --fatal-infos;

pana: pana_pi pana_ios pana_android pana_huawei pana_appmetrica

pana_pi:
	cd $(PI_PATH); $(PANA_SCRIPT);

pana_ios:
	cd $(IOS_PATH); $(PANA_SCRIPT);

pana_android:
	cd $(ANDROID_PATH); $(PANA_SCRIPT);

pana_huawei:
	cd $(HUAWEI_PATH); $(PANA_SCRIPT);

pana_appmetrica:
	cd $(APPMETRICA_PATH); $(PANA_SCRIPT);