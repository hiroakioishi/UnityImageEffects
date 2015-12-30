
// This is port of below code.
// [Shadertoy] Triangle Post-Processing
// https://www.shadertoy.com/view/ls2SDG

Shader "Hidden/irishoak/ImageEffects/TrianglePostProcessing" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Value;
	uniform float _ScreenAspectRatio;
	
	bool IsLessThan(float3 a, float3 b)
	{
	    return ( a.x <= b.x || a.y <= b.y || a.z <= b.z );
	}

	float3 SRGBToLinear(in float3 sRGBCol)
	{
		float3 linearRGBLo = sRGBCol / 12.92;
		float3 linearRGBHi = pow( ( sRGBCol + 0.055 ) / 1.055, float3( 2.4 ) );
		float3 linearRGB = IsLessThan( sRGBCol, float3( 0.04045 ) ) ? linearRGBLo : linearRGBHi;
		return linearRGB;
	}

	float3 linearToSRGB(in float3 linearCol)
	{
		float3 sRGBLo = linearCol * 12.92;
		float3 sRGBHi = (pow(abs( linearCol ), float3( 1.0 / 2.4 ) ) * 1.055 ) - 0.055;
		float3 sRGB   = IsLessThan( linearCol, float3( 0.0031308 ) ) ? sRGBLo : sRGBHi;
		return sRGB; //pow( linearCol, float3( 1.0 / 2.2 ) );
	}

	//

	const int   samples  = 2;
	const float fSamples = float( samples * samples * 2 * 2 );
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float scale = _Value;//( 0.4 + sin( iGlobalTime * 0.5 ) * 0.2 ) * 110.0;
		float2 uv = i.uv.xy;
	    uv.x *= _ScreenAspectRatio;
	    
	    float2 mosaicUV = floor( uv * scale ) / scale;
	    uv  -= mosaicUV;
	    uv  *= scale;
	    
	    float2 triOffset = float2( 
	        step( 1.0 - uv.y, uv.x ) / ( 2.0 * scale ),                                        
	        step(       uv.x, uv.y ) / ( 2.0 * scale ) 
	    );
	    
	   	float2 sampleUV = mosaicUV + triOffset;
		sampleUV.x /= _ScreenAspectRatio;
	    
	    float3 sample = float3( 0.0 );
	    for( int x = -samples; x < samples; x++ )
	    {
	    	for( int y = -samples; y < samples; y++ )
	        {
	            float2 subSampleUV = sampleUV;
	            subSampleUV += ( float2( _ScreenAspectRatio, 1.0 ) / float2( scale * fSamples ) ) 
	                           * float2( float( samples + x ), float( samples + y ) );
	    		sample += SRGBToLinear( tex2D(_MainTex, subSampleUV ).rgb );
	        }
	    }
	    sample /= fSamples;

		return float4( linearToSRGB( sample ), 1.0 );
		
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