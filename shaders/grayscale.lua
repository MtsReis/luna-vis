return [[
uniform float intensity;

mat4 saturationMatrix( float saturation )
{
    vec3 luminance = vec3( 0.3086, 0.6094, 0.0820 );
    float oneMinusSat = 1.0 - saturation;
    
    vec3 red = vec3( luminance.x * oneMinusSat ) + vec3( saturation, 0, 0 );
    vec3 green = vec3( luminance.y * oneMinusSat ) + vec3( 0, saturation, 0 );
    vec3 blue = vec3( luminance.z * oneMinusSat ) + vec3( 0, 0, saturation );
    
    return mat4( red,     0,
                 green,   0,
                 blue,    0,
                 0, 0, 0, 1 );
}

vec4 effect(vec4 colour, Image image, vec2 uvs, vec2 screen_coords) {
  vec4 pixel = Texel(image, uvs);
  vec4 result = saturationMatrix(intensity) * pixel;
    
	return  vec4(result.rgb * colour.rgb, pixel.a);
}
]]