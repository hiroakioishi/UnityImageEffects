
// This is port of below code.
// [GitHub] stackgl/glsl-halftone
// https://github.com/stackgl/glsl-halftone/blob/master/index.glsl

Shader "Hidden/irishoak/ImageEffects/CMYKHalftone" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	#include "snoise.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Value;
	uniform float _DotSize;
	
	uniform float2 _ScreenResolution;
	
	float aastep(float threshold, float value) {
		return step(threshold, value);
	}

	float3 halftone(float3 texcolor, float2 st, float frequency) {
		
		float n = 0.1 * snoise(st*200.0); // Fractal noise
		n += 0.05  * snoise(st*400.0);
		n += 0.025 * snoise(st*800.0);
		float3 white = float3(n*0.2 + 0.97, n*0.2 + 0.97, n*0.2 + 0.97);
		float3 black = float3(n + 0.1, n + 0.1, n + 0.1);

		// Perform a rough RGB-to-CMYK conversion
		float4 cmyk;
		cmyk.xyz = 1.0 - texcolor;
		cmyk.w = min(cmyk.x, min(cmyk.y, cmyk.z)); // Create K
		cmyk.xyz -= cmyk.w; // Subtract K equivalent from CMY

		// Distance to nearest point in a grid of
		// (frequency x frequency) points over the unit square
		float2 Kst = mul(frequency * float2x2(0.707, -0.707, 0.707, 0.707), st);
		float2 Kuv = 2.0 * frac(Kst)-1.0;
		float k = aastep(0.0, sqrt(cmyk.w)-length(Kuv)+n);
		float2 Cst = mul(frequency * float2x2(0.966, -0.259, 0.259, 0.966), st);
		float2 Cuv = 2.0 * frac(Cst)-1.0;
		float c = aastep(0.0, sqrt(cmyk.x)-length(Cuv)+n);
		float2 Mst = mul(frequency * float2x2(0.966, 0.259, -0.259, 0.966), st);
		float2 Muv = 2.0 * frac(Mst)-1.0;
		float m = aastep(0.0, sqrt(cmyk.y)-length(Muv)+n);
		float2 Yst = frequency * st; // 0 deg
		float2 Yuv = 2.0 * frac(Yst)-1.0;
		float y = aastep(0.0, sqrt(cmyk.z)-length(Yuv)+n);

		float3 rgbscreen = 1.0 - 0.9 * float3(c,m,y) + n;
		return lerp(rgbscreen, black, 0.85 * k + 0.3 * n);
	}

	float3 halftone(float3 texcolor, float2 st) {
		return halftone(texcolor, st, 30.0);
	}
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		 fixed4 texcolor = tex2D(_MainTex, i.uv);

		//aspect corrected texture coordinates
		float2 st = i.uv;
		st.x *= (_ScreenResolution.x / _ScreenResolution.y);

		//apply halftone effect
		return fixed4(lerp(tex2D(_MainTex, i.uv).xyz, halftone(texcolor.rgb, st * _DotSize), _Value), 1.0);
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