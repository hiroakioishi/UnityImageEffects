
// This is port of below code.
// [Shadertoy] Knitted
// https://www.shadertoy.com/view/4ts3zM

Shader "Hidden/irishoak/ImageEffects/Knitted" {
	Properties {
		_MainTex ("-", 2D) = "" {}
	}
	
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	uniform sampler2D _MainTex;
	float4 _MainTex_TexelSize;
	
	uniform float2 _TileSize = float2(0.05, 0.05);
	uniform float  _Threads  = 4.00;
	
	uniform float _Value;
	
	fixed4 frag (v2f_img i) : SV_Target
	{
		float2 uv = i.uv;
		float2 posInTile = fmod (float2(uv), _TileSize);
		float2 tileNum   = floor(float2(uv)/ _TileSize);
		
		float2 nrmPosInTile = posInTile / _TileSize;
		tileNum.y += floor(abs(nrmPosInTile.x - 0.5) + nrmPosInTile.y);
		float2 texCoord = tileNum * _TileSize;
 
  		float3 color = tex2D(_MainTex, texCoord).rgb;

  		color *= frac((nrmPosInTile.y + abs(nrmPosInTile.x - 0.5)) * floor(_Threads));

  		return fixed4(color, 1.0);
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