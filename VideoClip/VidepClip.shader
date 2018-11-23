Shader "Rolan/VidepClip"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		   _Threshold("Threshold", Range(0, 1)) = 0
          _R("R",Range(0, 1))=0
          _G("G",Range(0, 1)) = 0
        _B("B",Range(0, 1)) = 0
		_Channel("通道(0=r,1=g,2=b,3=a)",float ) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue" = "Transparent"  }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha 

		Pass
		{
			CGPROGRAM 
			#pragma vertex vert
			#pragma fragment frag	
			#include "UnityCG.cginc"


			

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
		
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _R;
			float _G;
			float _B;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed3 tex = col.rgb;
				float alpha;
				if (col.g >_G&&col.b<_B&&col.r<_R) {
                 col.a = 0;}


				return fixed4 (tex,  col.a );
				
			}
			ENDCG
		}
	}
}


