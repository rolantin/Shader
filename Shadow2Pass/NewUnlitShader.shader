Shader "Custom/PlayerShadow"  //http://gad.qq.com/article/detail/288626
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white"{}
		_ShadowInvLen ("ShadowInvLen", float) = 1.0 //0.4449261
		_Power("Power", Range(0,2)) = 1.7
	}
	SubShader
	{
		Tags{ "RenderType" = "Opaque" "Queue" = "Geometry+10"}
		LOD 100
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Power;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv) * _Power;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	Pass
		{
			Blend SrcAlpha  OneMinusSrcAlpha
			ZWrite Off
			Cull Back
			ColorMask RGB
			Stencil
			{
				Ref 0
				Comp Equal
				WriteMask 255
				ReadMask 255
				//Pass IncrSat
				Pass Invert
				Fail Keep
				ZFail Keep
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			float4 _ShadowPlane; //渲染的地面
			float4 _ShadowProjDir; //渲染的光源点，这里只是记录点的位置，用于计算阴影的投影
			float4 _WorldPos;
			float _ShadowInvLen; //阴影的长度
			float4 _ShadowFadeParams; //阴影渐变的参数
			struct appdata
			{
				float4 vertex : POSITION;
			};
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 xlv_TEXCOORD0 : TEXCOORD0;
				float3 xlv_TEXCOORD1 : TEXCOORD1;
			};
			v2f vert(appdata v)
			{
				v2f o;
				float3 lightdir = normalize(_ShadowProjDir); //单位化光照方向向量
				float3 worldpos = mul(unity_ObjectToWorld, v.vertex).xyz; //模型坐标转成世界坐标
				// _ShadowPlane.w = p0 * n  // 平面的w分量就是p0 * n
				float distance = (_ShadowPlane.w - dot(_ShadowPlane.xyz, worldpos)) / dot(_ShadowPlane.xyz, lightdir.xyz); //计算阴影的长度
				worldpos = worldpos + distance * lightdir.xyz; //影子的投影点
				o.vertex = mul(unity_MatrixVP, float4(worldpos, 1.0));
				o.xlv_TEXCOORD0 = _WorldPos.xyz;
				o.xlv_TEXCOORD1 = worldpos;  //影子投影的点组成的纹理
				return o;
			}
			float4 frag(v2f i) : SV_Target
			{
				float3 posToPlane_2 = (i.xlv_TEXCOORD0 - i.xlv_TEXCOORD1);
				float4 color;
				color.xyz = float3(0.0, 0.0, 0.0);
				color.w = (pow((1.0 - clamp(((sqrt(dot(posToPlane_2, posToPlane_2)) * _ShadowInvLen) - _ShadowFadeParams.x), 0.0, 1.0)), _ShadowFadeParams.y) * _ShadowFadeParams.z);  //透明度渐变计算
				return color;
			}
			ENDCG
		}
	}
}