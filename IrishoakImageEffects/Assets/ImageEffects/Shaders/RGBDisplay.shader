
// I used this code as reference.
// [Shadertoy] RGB display
// https://www.shadertoy.com/view/4dX3DM

Shader "Hidden/irishoak/ImageEffects/RGBDisplay" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float  _CellSize;
	float2 _ScreenResolution;
			
	uniform fixed4 _IntervalColor;
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float RESX = _ScreenResolution.x;
		float RESY = _ScreenResolution.y;
		
		int   CELL_SIZE       = int(_CellSize);
		float CELL_SIZE_FLOAT = float(CELL_SIZE);
		int   RED_COLUMNS     = int(CELL_SIZE_FLOAT / 3.0);
		int   GREEN_COLUMNS   = CELL_SIZE - RED_COLUMNS;
		
		float  time       = _Time.y;
		float2 resolution = float2(1,1);
		float2 coord      = i.uv.xy;
		
		float2 p = floor(float2(coord.x * RESX, coord.y * RESY) / CELL_SIZE_FLOAT) * CELL_SIZE_FLOAT;
		int offsetx = int(fmod(coord.x * RESX, CELL_SIZE_FLOAT));
		int offsety = int(fmod(coord.y * RESY, CELL_SIZE_FLOAT));

		float4 sum = tex2D( _MainTex, coord.xy );
		
		fixed4 finalColor = fixed4(_IntervalColor.x, _IntervalColor.y, _IntervalColor.z, 1.0);
		
		if (offsety < CELL_SIZE - 1) {		
			if (offsetx < RED_COLUMNS) {
				finalColor.r = sum.r;
			} else if ( offsetx < GREEN_COLUMNS ) {
				finalColor.g = sum.g;
			} else {
				finalColor.b = sum.b;
			}
		}
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