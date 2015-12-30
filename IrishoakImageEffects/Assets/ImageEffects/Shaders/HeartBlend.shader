
// This is port of below code.
// [Shadertoy] Heart Blend
// https://www.shadertoy.com/view/MlB3zw

Shader "Hidden/irishoak/ImageEffects/HeartBlend" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float2 uv = i.uv.xy;
     
	    uv.x = (abs(uv.x * 2.0 - 1.0));
	    uv.y = (abs(uv.y * 2.0 - 1.0));
	    
	    float2 left  = float2(uv.x - sin(uv.x * uv.y), uv.x);
	    float2 right = float2(uv.x + sin(uv.x * uv.y), uv.y);
	     
	    float4 color = tex2D(_MainTex, left) * tex2D(_MainTex, right);
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