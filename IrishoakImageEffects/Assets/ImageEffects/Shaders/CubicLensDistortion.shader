
// This is port of below code.
// [Shadertoy] Cubic Lens Distortion Shader
// https://www.shadertoy.com/view/4lSGRw

Shader "Hidden/irishoak/ImageEffects/CubicLensDistortion" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	#define PI_H 1.57079632679
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Value;
	
	float2 computeUV(float2 uv, float k, float kcube){
    
    float2 t = uv - .5;
    float r2 = t.x * t.x + t.y * t.y;
	float f = 0.;
    
    if( kcube == 0.0){
        f = 1. + r2 * k;
    }else{
        f = 1. + r2 * ( k + kcube * sqrt( r2 ) );
    }
    
    float2 nUv = f * t + .5;
    
    return nUv;
    
}
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float distortionStrength = _Value;
		float time = distortionStrength * PI_H;
		float2 uv = i.uv.xy;
	    float k = 1.0 * sin( time * .9 );
	    float kcube = .5 * sin( time );
	    
	    float offset = .1 * sin( time * .5 );
	    
	    float red   = tex2D( _MainTex, computeUV( uv, k + offset, kcube ) ).r; 
	    float green = tex2D( _MainTex, computeUV( uv, k,          kcube ) ).g; 
	    float blue  = tex2D( _MainTex, computeUV( uv, k - offset, kcube ) ).b; 
	    
	    return float4( red, green,blue, 1. );
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