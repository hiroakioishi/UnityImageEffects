Shader "Hidden/irishoak/ImageEffects/Miller" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Value; // v < 0.5 : Left copy, v >= 0.5 : Right copy
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float2 uv = i.uv;
		if (_Value < 0.5) {
			if (uv.x > 0.5) {
				uv.x = 1.0 - uv.x;
			}
		} else {
			if (uv.x <= 0.5) {
				uv.x = 1.0 - uv.x;
			}
		}
		
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