
// This is port of below.
// [Shadertoy] Palette Quantization & Dithering
// https://www.shadertoy.com/view/4ddGWr

Shader "Hidden/irishoak/ImageEffects/PaletteQuantizationAndDithering" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform sampler2D _DitheringTex;
	uniform float2    _ScreenResolution;
	
	// for a dramatic display of the value of dithering,
	// use these settings.
	//const float PaletteRGBSize = 2.;// only 1 bit per R G B (8-color palette)
	//const float ResolutionDivisor = 1.;// 1 pixel = 1 pixel, the finest visible.


	const float PaletteRGBSize    = 8.0;// number of values possible for each R, G, B.
	const float ResolutionDivisor = 2.0;

	//#define USE_BAYER4x4
	#define USE_BAYER8x8
	//#define USE_NOISE
	//#define USE_ANIM_NOISE

	//----------------------------------------------------------------------------

	float quantize(float inp, float period)
	{
	    return floor((inp+period/2.)/period)*period;
	}
	float2 quantize(float2 inp, float2 period)
	{
	    return floor((inp+period/2.)/period)*period;
	}


	//----------------------------------------------------------------------------
	float bayer4x4(float2 uvScreenSpace)
	{
		float2 bayerCoord = floor(uvScreenSpace / ResolutionDivisor);
	    bayerCoord = fmod(bayerCoord, 4.);
	    const float4x4 bayerMat = float4x4(
	    1,9,3,11,
	    13,5,15,7,
	    4,12,2,10,
	    16,8,14,6) / 16.;
	    int bayerIndex = int(bayerCoord.x + bayerCoord.y * 4.);
	    if(bayerIndex == 0) return bayerMat[0][0];
	    if(bayerIndex == 1) return bayerMat[0][1];
	    if(bayerIndex == 2) return bayerMat[0][2];
	    if(bayerIndex == 3) return bayerMat[0][3];
	    if(bayerIndex == 4) return bayerMat[1][0];
	    if(bayerIndex == 5) return bayerMat[1][1];
	    if(bayerIndex == 6) return bayerMat[1][2];
	    if(bayerIndex == 7) return bayerMat[1][3];
	    if(bayerIndex == 8) return bayerMat[2][0];
	    if(bayerIndex == 9) return bayerMat[2][1];
	    if(bayerIndex == 10) return bayerMat[2][2];
	    if(bayerIndex == 11) return bayerMat[2][3];
	    if(bayerIndex == 12) return bayerMat[3][0];
	    if(bayerIndex == 13) return bayerMat[3][1];
	    if(bayerIndex == 14) return bayerMat[3][2];
	    if(bayerIndex == 15) return bayerMat[3][3];

	    return 10.;// impossible
	}

	float bayer8x8(float2 uvScreenSpace)
	{
	    return tex2D(_DitheringTex, uvScreenSpace/(ResolutionDivisor*8.)).r;
	}

	float3 getSceneColor(float2 uv)
	{
	    return tex2D(_MainTex, uv).rgb;
	}

	float rand(float2 co){
	  return frac(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
	}
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float2 uv = i.uv.xy;// 0-1
		float2 fragCoord = i.uv.xy * _ScreenResolution;
    
	    // space between values of the dest palette
	    float3 quantizationPeriod = float3(1./(PaletteRGBSize-1.));
	    
		float2 uvPixellated = floor(fragCoord / ResolutionDivisor) * ResolutionDivisor;
	    
	    // original color panel---------------------
	    float3 originalCol = getSceneColor(uv);
	    
	    // dithered panel---------------------
	    float3 dc = getSceneColor(uvPixellated / _ScreenResolution.xy);
	    // apply bayer matrix, perturbing the original color values.
#ifdef USE_BAYER4x4
  	  dc += (bayer4x4(fragCoord)-.5)*(quantizationPeriod);
#endif
#ifdef USE_BAYER8x8
		dc += (bayer8x8(fragCoord)-.5)*(quantizationPeriod);
#endif
#ifdef USE_NOISE
		dc += (rand(uvPixellated)-.5)*(quantizationPeriod);
#endif
#ifdef USE_ANIM_NOISE
		dc += (rand(float2(rand(uvPixellated),iDate.w))-.5)*(quantizationPeriod);
#endif
	    // quantize color to palette
	    dc = float3(
	        quantize(dc.r, quantizationPeriod.r),
	        quantize(dc.g, quantizationPeriod.g),
	        quantize(dc.b, quantizationPeriod.b)
        );
   
	    // quantize to palette (raw quantization panel)---------------------
	    float3 qc = getSceneColor(uvPixellated / _ScreenResolution.xy);
	    qc = float3(
	        quantize(qc.r, quantizationPeriod.r),
	        quantize(qc.g, quantizationPeriod.g),
	        quantize(qc.b, quantizationPeriod.b)
	    );
		
		fixed4 fragColor = (fixed4)0;

	    // framing and post
	    //float ySplit = (iMouse.y > 0.0 ? iMouse.y / iResolution.y : 0.3);
	    //float xSplit = .7;
	    float ySplit = 0.0;
	    float xSplit = 1.0;
	    //if(iMouse.x > 0.) xSplit = iMouse.x / iResolution.x;
	    
	    if(uv.x > xSplit)
		    fragColor = float4(originalCol, 1);
	    else
	    {
	        if(uv.y > ySplit)
			    fragColor = float4(dc, 1);
	        else
			    fragColor = float4(qc, 1);
	    }

	    float f = abs(uv.x - xSplit);
	    fragColor.rgb *= smoothstep(.00,.005, f);
	    f = abs(uv.y - ySplit);
	    if(uv.x < xSplit)
		    fragColor.rgb *= smoothstep(.00,.005, f);
		return fragColor;
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