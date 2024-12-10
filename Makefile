main:
	@swift build
	@cp .build/debug/MistralCmd mistral
	@chmod +x mistral
	@echo "Run the program with ./mistral"

