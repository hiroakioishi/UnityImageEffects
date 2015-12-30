
// This is port of below
// Microprism Mosaic
// https://www.shadertoy.com/view/4tj3DD

// This code has something wrong...

Shader "Hidden/irishoak/ImageEffects/MicroprismMosaic" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float  _ScreenAspectRatio;
	uniform float2 _ScreenResolution;
	uniform float  _Value;
	uniform float  _CellSize;
	
	const float minCells     = 1.;
	const float maxCells     = 50.;
	const float defaultCells = 12.;
	const float aberration   = 1.05;

	const float triAspect = 0.866; //sqrt(3.)/ 2.;
	
	
	float hitTest(float2 uv, float2 cellSize) {

	    float2 cellOffset = fmod(uv,cellSize) / cellSize;
	    float2 cellIdx    = floor(uv/cellSize);
	    float2 subCellIdx = float2(cellIdx.x*2. + step(0.5,cellOffset.x), cellIdx.y);

	    float oddRow    = sign(fmod(subCellIdx.y,2.));
	    float oddSubCol = sign(fmod(subCellIdx.x,2.));
	    
		float testTopLeft = 1.0 - fmod(oddRow + oddSubCol, 2.0);
	    
	    float tlScore = (fmod(cellOffset.x, 0.5) * 2.0) - (1.0 - cellOffset.y);
	    float trScore = cellOffset.y - (fmod(cellOffset.x, 0.5) * 2.0);
	    float tbScore = (frac(cellOffset.y + 0.5) - 0.5) * 2.0;
	    
	    float oddEven = sign(lerp(tlScore, trScore, testTopLeft));
	    
	    // +/- for odd/even triangles, magnitude is distance from nearest edge
	    return oddEven * min(abs(lerp(tlScore, trScore, testTopLeft)), abs(tbScore));
	}

	float distFromTriCentre(float2 uv, float2 cellSize, float hitScore) {
	
	    float2 cellIdx = floor(uv/cellSize);
	    float  oddRow  = sign(fmod(cellIdx.y, 2.0));
	    float  oddTri  = 1.0 - fmod(oddRow + hitScore, 2.0);

	    float2 cellOffset = fmod(uv, cellSize) / cellSize;
	    cellOffset.x = frac(cellOffset.x + 0.5 * sign(1.0 - oddTri));
	        
	    float2 triOffset = float2((cellOffset.x - 0.5), 
	               lerp(cellOffset.y-(1.0 / 3.0),
	                   cellOffset.y-(1.0 - (1.0 / 3.0)),
	                   hitScore));

	    return length(triOffset) * 3.0 / 2.0;
	}

	float2 fixUV(float2 uv) {

	    // flip y unless video
	    return float2(uv.x, lerp(1.0 - uv.y, uv.y, sign(_Time.y)));
	}
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		// set offset via mouse-x if button down, else timer
//		float2 offset = lerp(float2(0.4 * sin(_Time.y / 1.5), 0.0),
//		                     float2(0.5 - (iMouse.x / iResolution.x), 0.0),
//		                     step(1.0, iMouse.z));
		//float2 offset = float2(0.4 * sin(_Time.y / 1.5), 0.0);
		float offset = float2(0.5, 0.0);
		//offset = mul(float2(0.4 * sin(_Time.y / 1.5), 0.0), fixed2x2(0.9659, - 0.2588, 0.2588, 0.9659)); // 15deg rotation

		// set mosaic density via mouse-y if button down, else default
//		float cellsHigh = lerp(defaultCells,
//		                  lerp(minCells, maxCells, 1.0 - sqrt(1.0 - (iMouse.y / iResolution.y))),
//		                  step(1.,iMouse.z));
		//float cellsHigh = defaultCells;
		float cellsHigh = _CellSize;

		float cellsWide = cellsHigh * _ScreenAspectRatio * triAspect;
		float2 cellSize = float2(1.0 / cellsWide, 1.0 / cellsHigh);

//		float2 uv = fixUV(fragCoord.xy / iResolution.xy);
		float2 uv = fixUV(i.uv.xy);
		
		// find whether co-ord in 'odd' or 'even' cell
		//float score = hitTest(uv - 0.5, cellSize);
		float score = hitTest(uv, cellSize);
		float oddEven = step(0.0, score);

		// texture lookup with chroma spread
		float2 uvTranslate = 0.5 * cellSize * lerp(-offset / 4.0, offset, oddEven);
		float chromAbr = pow(aberration, sqrt(1.2 * cellsHigh));
		float4 txColor = float4(  	
			tex2D(_MainTex, clamp(uv + (uvTranslate / chromAbr), 0.0, 1.0)).x,
			tex2D(_MainTex, clamp(uv + uvTranslate, 0.0, 1.0)).y,
			tex2D(_MainTex, clamp(uv + (chromAbr * uvTranslate), 0.0, 1.0)).z,
		    1.0);

		// vary brightness based on offset, distance from top of cell
		float bright = (0.04 + (0.04 * length(offset) / 0.5)) * (1.0 - (0.7 * frac((uv.y - 0.5) / cellSize.y)));
		fixed4 fragColor = lerp(txColor, lerp(pow(txColor, float4(2.0)), float4(1.0) - pow(float4(1.0) - txColor, float4(2.0)), oddEven), float4(bright, bright, bright, bright));

		// vignetting based on distance from centre of cell, attenuation by cell count
		float attn = pow(0.97, pow(cellsHigh, 1.3));
		float vignette = distFromTriCentre(uv - 0.5, cellSize, oddEven);
		fragColor -= 0.25 * attn * (1.0 - (pow(0.92, 3.0 * pow(vignette, 2.5))));

		// darken near tri edges
		float edges = 1.0 - pow(abs(score), 0.5);
		fragColor -= 0.5 * attn * (1.0 - (pow(0.9, 1.0 * pow(edges, 4.0))));
		
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