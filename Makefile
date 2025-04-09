main:
	@swift build
	@cp .build/debug/CLI mistral
	@chmod +x mistral
	@echo "Run the program with ./mistral"

