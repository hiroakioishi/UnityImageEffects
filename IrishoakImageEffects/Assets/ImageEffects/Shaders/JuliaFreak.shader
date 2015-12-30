
// This is port of below code.
// [Shadertoy] JuliaFreak
// https://www.shadertoy.com/view/XdXXzX

Shader "Hidden/irishoak/ImageEffects/JuliaFreak" {
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
		float2 uv = i.uv.xy - 0.5;
		const float2 M = float2(0.36, 0.196);
		uv = float2(uv.x*uv.x - uv.y*uv.y, 2.0 * uv.x * uv.y) + M;
		uv = float2(uv.x*uv.x - uv.y*uv.y, 2.0 * uv.x * uv.y) + M;
		uv = float2(uv.x*uv.x - uv.y*uv.y, 2.0 * uv.x * uv.y) + M;
		return float4(tex2D(_MainTex, uv));
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