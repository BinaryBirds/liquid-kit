test:
	swift test --parallel

test-with-coverage:
	swift test --parallel --enable-code-coverage

# arm64-apple-macosx
# x86_64-apple-macosx

code-coverage: test-with-coverage
	llvm-cov report \
        .build/arm64-apple-macosx/debug/liquid-kitPackageTests.xctest/Contents/MacOS/liquid-kitPackageTests \
        -instr-profile=.build/arm64-apple-macosx/debug/codecov/default.profdata \
        -ignore-filename-regex=".build|Tests" \
        -use-color

docs-preview:
	swift package --disable-sandbox preview-documentation --target LiquidKit

docs-generate:
	swift package generate-documentation \
        --target LiquidKit

docs-generate-static:
	swift package --disable-sandbox \
        generate-documentation \
        --transform-for-static-hosting \
        --hosting-base-path "LiquidKit" \
        --target LiquidKit \
        --output-path ./docs

