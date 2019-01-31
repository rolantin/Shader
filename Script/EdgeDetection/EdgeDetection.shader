// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Rolan/ImageEffect/EdgeDetection"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	   _EdgeOnly("EdgeOnly",Float) = 1
	   _EdgeColor("EdgeColor",Color) = (0,0,0,1)
	   _BackgroundColor("BackgroundColor",Color) = (1,1,1,1)
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

		sampler2D _MainTex;
	   fixed4 _EdgeColor;
	   fixed4 _BackgroundColor;
	   fixed _EdgeOnly;
	   half4 _MainTex_TexelSize;//unity3d 提供访问纹理对应的每个纹素的大小如512x512 值约 0.001953 （即1/512）
	   float4 _MainTex_ST;
	

			struct v2f
			{
				float2 uv[9] : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata_img v)
			{
				v2f o;
				//o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex = UnityObjectToClipPos(v.vertex);
				//o.uv = v.texcoord;
				half2 uv = v.texcoord;

				o.uv[0] = uv + _MainTex_TexelSize.xy * half2(-1, -1);
				o.uv[1] = uv + _MainTex_TexelSize.xy * half2(0, -1);
				o.uv[2] = uv + _MainTex_TexelSize.xy * half2(1, -1);
				o.uv[3] = uv + _MainTex_TexelSize.xy * half2(-1, 0);
				o.uv[4] = uv + _MainTex_TexelSize.xy * half2(0, 0);
				o.uv[5] = uv + _MainTex_TexelSize.xy * half2(1, 0);
				o.uv[6] = uv + _MainTex_TexelSize.xy * half2(-1, 1);
				o.uv[7] = uv + _MainTex_TexelSize.xy * half2(0,1);
				o.uv[8] = uv + _MainTex_TexelSize.xy * half2(1, 1);
				return o;
			}
			half Sobel(v2f i) {
				const half Gx[9] = { -1,-2,-1,0,0,0,1,2,1 };
				const half Gy[9] = { -1,0,1,-2,0,2,-1,0,1 };

				half texColor;
				half edgeX = 0;
				half edgeY = 0;
				for (int it = 0; it < 9; it++) {
					texColor = Luminance(tex2D(_MainTex, i.uv[it]));
					edgeX += texColor * Gx[it];
					edgeY += texColor * Gy[it];
				}
				half edge = 1 - abs(edgeX) - abs(edgeY);
				return edge;
			}
			fixed4 frag (v2f i) : SV_Target
			{//调用Sobel 函数计算 当前像素的梯度值edge
				half edge = Sobel(i);
			fixed4 withEdgeColor = lerp(_EdgeColor, tex2D(_MainTex, i.uv[4]), edge);
			fixed4 onlyEdgeColor = lerp(_EdgeColor, _BackgroundColor, edge);
			return lerp(withEdgeColor, onlyEdgeColor, _EdgeOnly);
			
			}
			ENDCG
		}
		
	}
		   FallBack Off
}
