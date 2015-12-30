
Shader "Hidden/irishoak/ImageEffects/EdgeFilter" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	#define AMPLIFER 50.0
	#define OFFSET_STRENGTH 0.001
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float3 _EdgeColor;
	uniform float  _Amplifer; 
	
	float4 getPixel (float2 uv, float x, float y) {
		return tex2D(_MainTex, uv.xy + float2(x, y));
	}
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		fixed4 sum = (fixed4)0.0;
		fixed2 uv = i.uv.xy;

		sum += abs(getPixel(uv, 0, 1 * OFFSET_STRENGTH) - getPixel(uv, 0, -1 * OFFSET_STRENGTH));
		sum += abs(getPixel(uv, 1 * OFFSET_STRENGTH, 0) - getPixel(uv, -1 * OFFSET_STRENGTH, 0));
		sum /= 2.0;
		float4 color = tex2D(_MainTex, uv);
		
		color.r += length(sum) * _Amplifer * _EdgeColor.r;
		color.g += length(sum) * _Amplifer * _EdgeColor.g;
		color.b += length(sum) * _Amplifer * _EdgeColor.b;
	
		return color;
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