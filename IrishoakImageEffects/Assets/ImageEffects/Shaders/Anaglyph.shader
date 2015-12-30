Shader "Hidden/irishoak/ImageEffects/Anaglyph" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Offset;
	uniform float _Value;
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		fixed R = tex2D(_MainTex, i.uv).r;
		fixed G = tex2D(_MainTex, i.uv + float2(_Offset, 0)).g;
		fixed B = tex2D(_MainTex, i.uv - float2(_Offset, 0)).b;
		return fixed4(R, G, B, 1.0);
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