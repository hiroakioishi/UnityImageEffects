Shader "Hidden/irishoak/ImageEffects/CircularDuplication" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	#define PI 3.14159265
	
	float _ScreenAspectRatio;
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Value;
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		
		float2 uvorg = i.uv;
		float2 uv;
		
		uvorg -= float2(0.5, 0.5); 
		fixed4 sumColor = (fixed4)0.0;
		
		if (_Value > 1) {
			for( int i = 0; i < _Value; i++){
				float angle = i * (2.0 * PI) / _Value;
				
				uv.x = cos(angle) * uvorg.x - sin(angle) * uvorg.y * 1/_ScreenAspectRatio;
				uv.y = sin(angle) * uvorg.x + cos(angle) * uvorg.y  * 1/_ScreenAspectRatio;
				
				uv += float2(0.5, 0.5);
				
				sumColor += tex2D(_MainTex, uv.xy);
			}
			return sumColor;
		} else {
			return tex2D(_MainTex, i.uv.xy);
		}
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