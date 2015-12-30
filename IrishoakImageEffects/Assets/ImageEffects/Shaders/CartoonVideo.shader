
// I used this code as reference.
// [Shadertoy] cartoon video - test
// https://www.shadertoy.com/view/ldl3WM

Shader "Hidden/irishoak/ImageEffects/CartoonVideo" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	#define PI 3.1415927
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Value; // Epsilon
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float2 uv = i.uv;
		float3 t   = tex2D(_MainTex, uv).rgb;
		float3 t00 = tex2D(_MainTex, uv + float2(-_Value,-_Value)).rgb;
		float3 t10 = tex2D(_MainTex, uv + float2( _Value,-_Value)).rgb;
		float3 t01 = tex2D(_MainTex, uv + float2(-_Value, _Value)).rgb;
		float3 t11 = tex2D(_MainTex, uv + float2( _Value, _Value)).rgb;
		float3 tm  = (t00+t01+t10+t11)/4.0;
		float3 v = t; float3 c;
		t = t - tm;
		t = t*t*t;
		v=t;
		v = 10000.0 * t;

		float g = (tm.x-.3)*5.;
		float3 col0 = float3(0.0, 0.0, 0.0);
		float3 col1 = float3(0.2, 0.5, 1.0);
		float3 col2 = float3(1.0, 0.8, 0.7);
		float3 col3 = float3(1.0, 1.0, 1.0);
		
		if      (g > 2.0) c = lerp(col2, col3, g - 2.0);
		else if (g > 1.0) c = lerp(col1, col2, g - 1.0);
		else              c = lerp(col0, col1, g);
			
		c = clamp(c, 0.0, 1.0);
		v = clamp(v, 0.0, 1.0);
		v = c * (1.0 - v); 
		v = clamp(v, 0.0, 1.0);
		
		return fixed4(v, 1.0);
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