return [[
uniform Image hSyncMap;

vec4 effect(vec4 colour, Image image, vec2 uvs, vec2 screen_coords) {
  vec4 hSyncMapPixel = Texel(hSyncMap, uvs);

  if (hSyncMapPixel.r == 1) {
    return Texel(image, uvs);
  }

  if (hSyncMapPixel.b == 1) {
    return vec4(0, 0, 0, 1);
  }

  vec2 offset = vec2(hSyncMapPixel.g, 0);
  vec4 pixel = Texel(image, uvs - offset);

  return pixel;
}]]
