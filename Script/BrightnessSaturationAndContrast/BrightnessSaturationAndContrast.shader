// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "RolanImageEffect/BrightnessSaturationAndContrast"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	   _Brightness("Brightness",Float) = 1
	   _Saturation("Saturation",Float) = 1
	   _Contrast("Contrast",Float) = 1
	}
		SubShader
	   {
		   Pass{
		   Ztest Always
		   Cull Off
		   ZWrite off
		  }
		   Tags { "RenderType" = "Opaque" }
		   LOD 100

		   Pass
		   {
			   CGPROGRAM
			   #pragma vertex vert
			   #pragma fragment frag
			   // make fog work
			   #pragma multi_compile_fog

			   #include "UnityCG.cginc"

	   half _Brightness;
	   half _Saturation;
	   half _Contrast;
	   sampler2D _MainTex;
	   float4 _MainTex_ST;

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata_img v)
			{
				v2f o;
				//o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 renderTex = tex2D(_MainTex,i.uv);
			fixed3 finalcolor = renderTex.rgb*_Brightness;
			fixed luminance = Luminance(renderTex.rgb);
			fixed3 luminanceColor = fixed3(luminance, luminance, luminance);
			finalcolor = lerp(luminanceColor, finalcolor, _Saturation);
		
			fixed3 avgcolor = fixed3(0.5, 0.5, 0.5);
			finalcolor = lerp(avgcolor, finalcolor, _Contrast);
				return fixed4(finalcolor,renderTex.a);
			}
			ENDCG
		}
		
	}
		   FallBack Off
}
