Shader "Hidden/irishoak/ImageEffects/HorizontalBlur" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Offset;
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		fixed4 sum = (fixed4)0.0;
		fixed2 uv = i.uv.xy;

	   	sum += tex2D(_MainTex, uv + fixed2(-4.0 * _Offset, 0.0)) * 0.05;
	   	sum += tex2D(_MainTex, uv + fixed2(-3.0 * _Offset, 0.0)) * 0.09;
	   	sum += tex2D(_MainTex, uv + fixed2(-2.0 * _Offset, 0.0)) * 0.12;
	   	sum += tex2D(_MainTex, uv + fixed2(-_Offset, 0.0)) * 0.15;
	   	sum += tex2D(_MainTex, uv + fixed2( 0.0, 0.0)) * 0.16;
	   	sum += tex2D(_MainTex, uv + fixed2(_Offset, 0.0)) * 0.15;
	   	sum += tex2D(_MainTex, uv + fixed2( 2.0 * _Offset, 0.0)) * 0.12;
	   	sum += tex2D(_MainTex, uv + fixed2( 3.0 * _Offset, 0.0)) * 0.09;
	   	sum += tex2D(_MainTex, uv + fixed2( 4.0 * _Offset, 0.0)) * 0.05;

		return sum;
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