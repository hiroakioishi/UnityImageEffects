
// This is port of below code.
// [Shadertoy] EM Interference Effect
// https://www.shadertoy.com/view/lsXSWl

Shader "Hidden/irishoak/ImageEffects/EMInterference" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Value;
	
	float rng2(float2 seed)
	{
	    return frac(sin(dot(seed * floor(_Time.y * 12.), fixed2(127.1, 311.7))) * 43758.5453123);
	} 

	float rng(float seed)
	{
	    return rng2 (fixed2 (seed, 1.0));
	}
	
	fixed4 frag (v2f_img i) : SV_Target
	{	
		fixed2 uv = i.uv.xy;
	    fixed2 blockS = floor(uv * fixed2(24.0, 9.0));
	    fixed2 blockL = floor(uv * fixed2( 8.0, 4.0));
	    
	    float r = rng2 (uv);
	    fixed3 noise = (fixed3(r, 1.0 - r, r / 2.0 + 0.5) * 1.0 - 2.0) * 0.08;
	    
	    float lineNoise = pow(rng2(blockS), 8.0) * pow(rng2(blockL), 3.0) - pow(rng(7.2341), 17.0) * 2.0;
	    
	    fixed4 col1 = tex2D(_MainTex, uv);
	    fixed4 col2 = tex2D(_MainTex, uv + fixed2(lineNoise * 0.05 * rng( 5.0), 0));
	    fixed4 col3 = tex2D(_MainTex, uv - fixed2(lineNoise * 0.05 * rng(31.0), 0));
	    
		fixed4 finalColor = lerp(tex2D(_MainTex, i.uv), fixed4(fixed3(col1.x, col2.y, col3.z) + noise, 1.0), _Value);
		
		return finalColor;
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