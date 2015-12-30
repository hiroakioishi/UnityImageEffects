
// This is port of below code.
// [Shadertoy] Broken Pixelsort 2
// https://www.shadertoy.com/view/MtfSRn#

Shader "Hidden/irishoak/ImageEffects/BrokenPixelsort2" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float _Value;
	
	uniform float2 _ScreenResolution;
	
	//by Vladimir Storm
	//https://twitter.com/vladstorm_

	#define SFT -1.

	float hash(float x) {
		return frac(sin(dot(float2(x,x) ,float2(12.9898,78.233))) * 43758.5453);
	}

	float hash2(float2 p){
	    return frac(sin(dot(p,float2(127.1,311.7))) * 43758.5453123);
	}

	float gray(float3 c){
	    return (c.r+c.g+c.b)/3.;
	}

	float3 gray3(float3 c){
	    return float3(gray(c));
	}

	float bm_diff(float color_top, float color_bottom){
	    return abs( color_top - color_bottom );
	}

	//max... ?
	float3 bm_max(float3 c1, float3 c2){
	    return ( gray(c1) > gray(c2) ) ? c1 : c2 ;
	}



	float3 dry(float2 p) {

	    return tex2D(_MainTex, 
	                     float2((p.x + 0.5) / _ScreenResolution.x, 
	                            (p.y + 0.5) / _ScreenResolution.y)
	                    ).rgb;
	}

	bool odd(float x){ return (fmod(x, 2.0) < 1.0); }

	float3 prev(float2 p) {
	    
	    if( p.x >= _ScreenResolution.x || p.y >= _ScreenResolution.y) return float3(1.0, 1.0, 1.0);
	    if( p.x<0. || p.y<0.) 							  return float3(0.0, 0.0, 0.0);    
	    return tex2D(_MainTex, (p+.5)/_ScreenResolution.xy).rgb;    
	    
	}
	//    return tex2D(_MainTex,float2((p.x+.5)/iResolution.x, (p.y+.5)/iResolution.y)).rgb;

	//color value
	float cv(float3 c){ return c.r+c.g+c.b; }

	//condition i - iteration
	bool cnd(float2 p, float i){
	    
	    return odd(p.x) || odd(i+1.) ;    

	}


	float3 compare(float3 c1, float3 c2, float2 p, float i){
	
		bool b;
		if (odd(p.x) && odd(i)) {
			b = false;
		} else if (!odd(p.x) &&  odd(i)) {
			b = true;
		} else if ( odd(p.x) && !odd(i)) {
			b = true;
		} else {
			b = false;
		}
		 
	    //if(odd(p.x) ^^ odd(i) ) 
	    if (b)
	       // return (cv(c1) > cv(c2)) ? c2:  bm_max(c1, float3(hash(c1.x)));
		   // return (cv(c1) > cv(c2)) ? c2:   float3( bm_diff(hash(c1.x), c1.x) );
		    return (cv(c1) > cv(c2)) ? c2:   float3( hash(c1.x) );
		else 
	        return (cv(c1) > cv(c2)) ? c1: c2;
	}
	float3 sort0(float2 p){
	  float3 c1 = prev(p), c2 = prev(p +float2( SFT, 0.) );
	  return compare(c1, c2, p, 0.);      
	}
	float3 sort1(float2 p){
	  float3 c1 = sort0(p), c2 = sort0(p+float2( SFT, 0.) );
	  return compare(c1, c2, p, 1.);      
	}
	float3 sort2(float2 p){
	  float3 c1 = sort1(p), c2 = sort1(p+float2( SFT, 0.) );
	  return compare(c1, c2, p, 2.);      
	}
	float3 sort3(float2 p){
	  float3 c1 = sort2(p), c2 = sort2(p+float2( SFT, 0.) );
	  return compare(c1, c2, p, 3.);      
	}
	float3 sort4(float2 p){
	  float3 c1 = sort3(p), c2 = sort3(p+float2( SFT, 0.) );
	  return compare(c1, c2, p, 4.);      
	}
	float3 sort5(float2 p){
	  float3 c1 = sort4(p), c2 = sort4(p+float2( SFT, 0.) );
	  return compare(c1, c2, p, 5.);      
	}
	float3 sort6(float2 p){
	  float3 c1 = sort5(p), c2 = sort5(p+float2( SFT, 0.) );
	  return compare(c1, c2, p, 6.);      
	}
	float3 sort7(float2 p){
	  float3 c1 = sort6(p), c2 = sort6(p+float2( SFT, 0.) );
	  return compare(c1, c2, p, 7.);      
	}
	float3 sort8(float2 p){
	  float3 c1 = sort7(p), c2 = sort7(p+float2( SFT, 0.) );
	  return compare(c1, c2, p, 8.);      
	}
	float3 sort9(float2 p){
	  float3 c1 = sort8(p), c2 = sort8(p+float2( SFT, 0.) );
	  return compare(c1, c2, p, 9.);      
	}

	float3 compare_h(float3 c1, float3 c2, float2 p, float i){
		
		bool b;
		if (odd(p.y) && odd(i)) {
			b = false;
		} else if (!odd(p.y) &&  odd(i)) {
			b = true;
		} else if ( odd(p.y) && !odd(i)) {
			b = true;
		} else {
			b = false;
		}
		 
	    //if(odd(p.y) ^^ odd(i) ) 
	    if (b)
		   // return (cv(c1) > cv(c2)) ? c2:  bm_max(c1, float3(hash(c1.x)));
		   // return (cv(c1) > cv(c2)) ? c2:   float3( bm_diff(hash(c1.x), c1.x) );
		    return (cv(c1) > cv(c2)) ? c2:   float3( hash(cv(c1)) ); //hash(cv(c1)) gray(c1)
		else 
	        return (cv(c1) > cv(c2)) ? c1: c2;
	}
	float3 sort0h(float2 p){
	    
	  return float3(
	    compare_h(prev(p),  prev(p +float2( 0., SFT*1.)) , p, 0.).x,      
	    compare_h(prev(p),  prev(p +float2( 0., SFT*2.)) , p, 0.).y,      
	    compare_h(prev(p),  prev(p +float2( 0., SFT*3.)) , p, 0.).z      
	  );
	}
	float3 sort1h(float2 p){
	  
	  return float3(
	    compare_h(sort0h(p), sort0h(p+float2( 0., SFT*1.) ), p, 1.).x,      
	    compare_h(sort0h(p), sort0h(p+float2( 0., SFT*2.) ), p, 1.).y,      
	    compare_h(sort0h(p), sort0h(p+float2( 0., SFT*3.) ), p, 1.).z      
	  );
	}
	float3 sort2h(float2 p){
	  
	  return float3(
	    compare_h(sort1h(p), sort1h(p+float2( 0., SFT*1.) ), p, 2.).x,      
	    compare_h(sort1h(p), sort1h(p+float2( 0., SFT*2.) ), p, 2.).y,      
	    compare_h(sort1h(p), sort1h(p+float2( 0., SFT*3.) ), p, 2.).z      
	  );
	}
	float3 sort3h(float2 p){
	  
	  return float3(
	    compare_h(sort2h(p), sort2h(p+float2( 0., SFT*1.) ), p, 3.).x,      
	    compare_h(sort2h(p), sort2h(p+float2( 0., SFT*2.) ), p, 3.).y,      
	    compare_h(sort2h(p), sort2h(p+float2( 0., SFT*3.) ), p, 3.).z      
	  );
	}


	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float2 fragCoord = i.uv.xy * _ScreenResolution;
		float2 p = float2(floor(fragCoord.x),floor(fragCoord.y));
	     //vec2 p = fragCoord.xy;
	    
	    float3 c = sort1h(p);//prev3
	    return float4(lerp(tex2D(_MainTex, i.uv).xyz, c, _Value), 1.0);
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