Shader "Hidden/irishoak/ImageEffects/ZoomOut" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	const int _ZoomOutCount = 24;
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Value; // v < 0.5 : Left copy, v >= 0.5 : Right copy
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float2 uv = i.uv;
		
		fixed4 col = tex2D(_MainTex, uv);
		for (int i = 0; i < _ZoomOutCount; i++) {
			float val = _Value * (1.0 / _ZoomOutCount) * i;
			if (uv.x < 1.0 - val && uv.y < 1.0 - val && uv.x > val && uv.y > val) {
				float scl = 0.5 / (0.5 - val);
				float2 suv = uv * scl + float2(-scl * 0.5 + 0.5, -scl * 0.5 + 0.5);
				col = tex2D(_MainTex, suv);
			}
		}
		return col;
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