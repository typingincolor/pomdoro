SCHEME := Pomodoro
PROJECT := Pomodoro.xcodeproj
CONFIG ?= Debug
DESTINATION := platform=macOS
DERIVED_DATA := $(shell xcodebuild -project $(PROJECT) -scheme $(SCHEME) -configuration $(CONFIG) -showBuildSettings 2>/dev/null | awk -F' = ' '/ BUILT_PRODUCTS_DIR =/ {print $$2; exit}')
APP := $(DERIVED_DATA)/$(SCHEME).app

.PHONY: help gen build test run release clean

help:
	@echo "Targets:"
	@echo "  gen       Regenerate $(PROJECT) via xcodegen"
	@echo "  build     Build $(SCHEME) ($(CONFIG))"
	@echo "  test      Run unit tests"
	@echo "  run       Build and launch the app"
	@echo "  release   Release build (CONFIG=Release)"
	@echo "  clean     xcodebuild clean"

gen:
	xcodegen generate

$(PROJECT): project.yml
	xcodegen generate

build: $(PROJECT)
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) -destination '$(DESTINATION)' -configuration $(CONFIG) build

test: $(PROJECT)
	xcodebuild test -project $(PROJECT) -scheme $(SCHEME) -destination '$(DESTINATION)' -only-testing:PomodoroTests

run: build
	open "$(APP)"

release:
	$(MAKE) build CONFIG=Release

clean:
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) -configuration $(CONFIG) clean
