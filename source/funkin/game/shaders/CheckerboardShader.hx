package funkin.game.shaders;

import flixel.system.FlxAssets.FlxShader;

class CheckerboardShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header
        
        uniform float uTime;
        uniform float uSpeed;
        uniform float uSize;
        uniform float uAlpha;
        uniform float uAngle;
        uniform vec3 uDarkColor;
        uniform vec3 uLightColor;
        
        void main()
        {
            vec2 uv = openfl_TextureCoordv * 2.0 - 1.0; // Convert to [-1,1] range
            
            // Apply rotation
            float angle = radians(uAngle);
            float cosA = cos(angle);
            float sinA = sin(angle);
            mat2 rot = mat2(cosA, -sinA, sinA, cosA);
            uv = rot * uv;
            
            // Diagonal movement with rotation
            uv.x += uTime * uSpeed * 0.5;
            uv.y += uTime * uSpeed * 0.5;
            
            // Checkerboard pattern
            float x = step(1.0, mod(uv.x * uSize, 2.0));
            float y = step(1.0, mod(uv.y * uSize, 2.0));
            float pattern = mod(x + y, 2.0);
            
            // Use colors with mix instead of black/white
            vec3 color = mix(uDarkColor, uLightColor, pattern);
            
            // Apply transparency
            gl_FragColor = vec4(color, uAlpha);
        }
    ')
	public function new()
	{
		super();
		uTime.value = [0];
		uSpeed.value = [1.4];
		uSize.value = [16.0];
		uAlpha.value = [0.7];
		uAngle.value = [45.0];

		// Set colors - using gray (#808080) instead of white
		uDarkColor.value = [0.0, 0.0, 0.0]; // Black
		uLightColor.value = [0.5, 0.5, 0.5]; // Gray (RGB 0.5,0.5,0.5)
	}

	public function update(elapsed:Float):Void
	{
		uTime.value[0] += elapsed;
	}
}
