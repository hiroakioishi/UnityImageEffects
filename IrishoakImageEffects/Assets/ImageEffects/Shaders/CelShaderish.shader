
// This is port of below code.
// [Shadertoy] Cel shaderish
// https://www.shadertoy.com/view/ld2XWD

Shader "Hidden/irishoak/ImageEffects/CelShaderish" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float2 _ScreenResolution;
	uniform float2 _InvScreenResolution;
	uniform float4 _EdgeColor;
	uniform float  _Threshold;
	
	float getTexture(float x, float y)
	{
	    return tex2D(_MainTex, float2(x, y) * _InvScreenResolution).x;
	}
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float x = i.uv.x * _ScreenResolution.x;
	    float y = i.uv.y * _ScreenResolution.y;
	    
	    float xValue = -getTexture(x-1.0, y-1.0) - 2.0*getTexture(x-1.0, y) - getTexture(x-1.0, y+1.0)
	        + getTexture(x+1.0, y-1.0) + 2.0*getTexture(x+1.0, y) + getTexture(x+1.0, y+1.0);
	    float yValue = getTexture(x-1.0, y-1.0) + 2.0*getTexture(x, y-1.0) + getTexture(x+1.0, y-1.0)
	        - getTexture(x-1.0, y+1.0) - 2.0*getTexture(x, y+1.0) - getTexture(x+1.0, y+1.0);
	    
	    if(length(float2(xValue, yValue)) > _Threshold)
	    {
	        return _EdgeColor;
	    }
	    else
	    {
	        float2 uv = float2(x, y) * _InvScreenResolution.xy;
	    	float4 currentPixel = tex2D(_MainTex, uv);
	        return currentPixel;
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