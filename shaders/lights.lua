return [[
uniform Image lightMap;
uniform float intensity;

vec4 effect(vec4 colour, Image image, vec2 uvs, vec2 screen_coords) {
  vec4 corEscuro = vec4(0.0001, 0.074, 0.176, 1);
  vec4 pixel = Texel(image, uvs);
  vec4 lightMapPixel = Texel(lightMap, uvs);

  if (lightMapPixel == vec4(0, 0, 0, 1)) {
    return pixel;
  }
  
  
  corEscuro.xyz = corEscuro.xyz * intensity + vec3(1, 1, 1) * lightMapPixel.a * intensity;
  pixel = pixel * corEscuro;

  return pixel;
}]]