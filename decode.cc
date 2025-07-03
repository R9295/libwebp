#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <vector>
#include "src/webp/decode.h"

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *d, size_t s) {
  std::vector<unsigned char> arbitrary_bytes(d, d + s);
  WebPDecoderConfig decoder_config;
  if (!WebPInitDecoderConfig(&decoder_config)) {
    fprintf(stderr, "WebPInitDecoderConfig failed.\n");
    std::abort();
  }
  const VP8StatusCode status =
      WebPDecode(reinterpret_cast<const uint8_t*>(arbitrary_bytes.data()),
                 arbitrary_bytes.size(), &decoder_config);
  WebPFreeDecBuffer(&decoder_config.output);
  // The decoding may fail (because the fuzzed input can be anything) but not
  // for these reasons.
  if (status == VP8_STATUS_SUSPENDED || status == VP8_STATUS_USER_ABORT) {
    std::abort();
  }
  return 0;
}
