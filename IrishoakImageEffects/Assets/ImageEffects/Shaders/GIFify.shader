
// This is port of below code.
// [Shadertoy] GIFify
// https://www.shadertoy.com/view/Mll3Df

Shader "Hidden/irishoak/ImageEffects/GIFify" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"

	#define STRENGTH 0.5
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Value;
	
	uniform float2 _ScreenResolution;
	
	static const float strength   = 0.5;
	static const float gamma      = 0.6;
	static const float brightness = 1.4;
	
	float orig = 0.5; // 1.0 - sctrength

	float luma(float4 rgba) {
		float3 W = float3(0.2125, 0.7154, 0.0721);
		return dot(rgba.xyz, W);
	}


	float dither8x8(float2 position, float lum) {
		int x = int(fmod(position.x, 8.0));
		int y = int(fmod(position.y, 8.0));
		int index = x + y * 8;
		float limit = 0.0;

		if (x < 8) {
			if (index == 0) limit = 0.015625;
			if (index == 1) limit = 0.515625;
			if (index == 2) limit = 0.140625;
			if (index == 3) limit = 0.640625;
			if (index == 4) limit = 0.046875;
			if (index == 5) limit = 0.546875;
			if (index == 6) limit = 0.171875;
			if (index == 7) limit = 0.671875;
			if (index == 8) limit = 0.765625;
			if (index == 9) limit = 0.265625;
			if (index == 10) limit = 0.890625;
			if (index == 11) limit = 0.390625;
			if (index == 12) limit = 0.796875;
			if (index == 13) limit = 0.296875;
			if (index == 14) limit = 0.921875;
			if (index == 15) limit = 0.421875;
			if (index == 16) limit = 0.203125;
			if (index == 17) limit = 0.703125;
			if (index == 18) limit = 0.078125;
			if (index == 19) limit = 0.578125;
			if (index == 20) limit = 0.234375;
			if (index == 21) limit = 0.734375;
			if (index == 22) limit = 0.109375;
			if (index == 23) limit = 0.609375;
			if (index == 24) limit = 0.953125;
			if (index == 25) limit = 0.453125;
			if (index == 26) limit = 0.828125;
			if (index == 27) limit = 0.328125;
			if (index == 28) limit = 0.984375;
			if (index == 29) limit = 0.484375;
			if (index == 30) limit = 0.859375;
			if (index == 31) limit = 0.359375;
			if (index == 32) limit = 0.0625;
			if (index == 33) limit = 0.5625;
			if (index == 34) limit = 0.1875;
			if (index == 35) limit = 0.6875;
			if (index == 36) limit = 0.03125;
			if (index == 37) limit = 0.53125;
			if (index == 38) limit = 0.15625;
			if (index == 39) limit = 0.65625;
			if (index == 40) limit = 0.8125;
			if (index == 41) limit = 0.3125;
			if (index == 42) limit = 0.9375;
			if (index == 43) limit = 0.4375;
			if (index == 44) limit = 0.78125;
			if (index == 45) limit = 0.28125;
			if (index == 46) limit = 0.90625;
			if (index == 47) limit = 0.40625;
			if (index == 48) limit = 0.25;
			if (index == 49) limit = 0.75;
			if (index == 50) limit = 0.125;
			if (index == 51) limit = 0.625;
			if (index == 52) limit = 0.21875;
			if (index == 53) limit = 0.71875;
			if (index == 54) limit = 0.09375;
			if (index == 55) limit = 0.59375;
			if (index == 56) limit = 1.0;
			if (index == 57) limit = 0.5;
			if (index == 58) limit = 0.875;
			if (index == 59) limit = 0.375;
			if (index == 60) limit = 0.96875;
			if (index == 61) limit = 0.46875;
			if (index == 62) limit = 0.84375;
			if (index == 63) limit = 0.34375;
		}

		return lum < limit ? 0.0 : brightness;
	}

	float4 dither8x8(float2 position, float4 color) {
		float l = luma(color);
		l = pow(l, gamma);
		l -= 1.0/255.0;

		return float4(color.rgb * dither8x8(position, l), 1.0);
	}
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float2 uv = i.uv.xy;
    	float4 color = tex2D(_MainTex, uv);
    
    	return orig * color + strength * dither8x8(uv.xy * _ScreenResolution, color);
	}
	
	ENDCG
	
	
	SubShader {
		
		Pass {
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }
			CGPROGRAM
			#pragma target 3.0
			#pragma glsl
			#pragma vertex   vert_img
			#pragma fragment frag
			ENDCG
		} 
	}
	FallBack "Diffuse"
}