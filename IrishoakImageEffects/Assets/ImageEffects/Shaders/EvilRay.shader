
// This is port of below code
// [Shadertoy] Evil Britney
// https://www.shadertoy.com/view/llS3WG

Shader "Hidden/irishoak/ImageEffects/EvilRay" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Value;
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float3 p = float3(i.uv.xy - 0.5, 0.0);
		//p.xy *= 0.98;
		float3 o = tex2D(_MainTex, 0.5 + p.xy).rbb;
		for (float i = 0.0; i < 50.0; i++) {
			p.xy *= 0.98;
			float3 col = tex2D(_MainTex, 0.5 + p.xy);
			p.z += pow(max(0.0, 0.5 - length(col.rg)), 2.0) * exp(-i * 0.1);
		}
		return lerp(tex2D(_MainTex, i.uv), float4(o * o + p.z, 1.0), _Value);
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