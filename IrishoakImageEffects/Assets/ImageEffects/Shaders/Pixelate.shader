
// This is port of below
// [Shadertoy] Pixelate video
// https://www.shadertoy.com/view/MslXRl

Shader "Hidden/irishoak/ImageEffects/Pixelate" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float2 _ScreenResolution;
	uniform float  _CellSize;
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float  srX   = _ScreenResolution.x;
		float  srY   = _ScreenResolution.y;
		float  pitch = _CellSize;
		
		float2 uv   = i.uv.xy;
		float2 divs = float2(srX / pitch, srY / pitch);
		uv = floor(uv * divs) / divs;
		
		return tex2D(_MainTex, uv);
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