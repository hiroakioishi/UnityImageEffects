Shader "Hidden/irishoak/ImageEffects/NoiseFilter" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	#include "snoise.cginc"
	
	// Global Params
	float _ScreenAspectRatio = 1.0f;
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	uniform float3 _Params; // 0: Strength, 1: Density, 2: Speed
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float  time = _Time.y;
		float2 uv = i.uv.xy; 
		float  n0 = snoise(float3(uv.x * _ScreenAspectRatio * _Params.y, uv.y * _Params.y, time * _Params.z      ));
		float  n1 = snoise(float3(uv.x * _ScreenAspectRatio * _Params.y, uv.y * _Params.y, time * _Params.z * 0.5));
		return tex2D(_MainTex, float2(frac(uv.x + n0 * _Params.x), frac(uv.y + n1 * _Params.x)));
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