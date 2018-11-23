Shader "Unlit/NewUnlitShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
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
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}

///////////////v

#version 100


attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _Time;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 unity_World2Shadow[4];
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
uniform highp vec4 unity_FogParams;
uniform highp vec4 _NormalMap_ST;
uniform highp vec4 _MaskMap_ST;
uniform highp vec4 _Speed;
uniform highp vec4 _Wave1;
uniform highp vec4 _Wave2;
uniform highp vec4 _Wave3;
uniform highp vec4 _Wave4;
uniform highp vec4 _VertexWaveAmplitudeSpeed;
uniform highp vec4 _ReflectionTex_ST;
uniform highp mat4 _ProjMatrix;
varying highp vec4 xlv_COLOR;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying mediump vec4 xlv_TEXCOORD6;
varying highp float xlv_TEXCOORD7;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = _glesColor;
  highp vec4 vertex_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  highp vec4 tmpvar_7;
  highp vec3 tmpvar_8;
  mediump vec4 tmpvar_9;
  vertex_2.yw = _glesVertex.yw;
  vertex_2.x = (_glesVertex.x + (sin(
    (_glesVertex.x + ((200.0 * _Time.y) * _VertexWaveAmplitudeSpeed.z))
  ) * _VertexWaveAmplitudeSpeed.x));
  vertex_2.z = (_glesVertex.z + (cos(
    (_glesVertex.z + ((100.0 * _Time.y) * _VertexWaveAmplitudeSpeed.w))
  ) * _VertexWaveAmplitudeSpeed.y));
  tmpvar_3 = (glstate_matrix_mvp * vertex_2);
  tmpvar_4 = tmpvar_1;
  highp vec2 tmpvar_10;
  tmpvar_10.x = _glesMultiTexCoord0.x;
  tmpvar_10.y = (_glesMultiTexCoord1.y * 0.5);
  tmpvar_5.xy = tmpvar_10;
  highp vec2 tmpvar_11;
  tmpvar_11.x = sin(_Wave1.w);
  tmpvar_11.y = cos(_Wave1.w);
  highp vec2 tmpvar_12;
  tmpvar_12 = (_glesVertex.xz * _NormalMap_ST.xy);
  tmpvar_6.xy = (((tmpvar_12 + _NormalMap_ST.zw) * _Wave1.y) + ((_Time.y * _Wave1.x) * tmpvar_11));
  highp vec2 tmpvar_13;
  tmpvar_13.x = sin(_Wave2.w);
  tmpvar_13.y = cos(_Wave2.w);
  tmpvar_6.zw = (((tmpvar_12 + _NormalMap_ST.zw) * _Wave2.y) + ((_Time.y * _Wave2.x) * tmpvar_13));
  highp vec2 tmpvar_14;
  tmpvar_14.x = sin(_Wave3.w);
  tmpvar_14.y = cos(_Wave3.w);
  tmpvar_7.xy = (((tmpvar_12 + _NormalMap_ST.zw) * _Wave3.y) + ((_Time.y * _Wave3.x) * tmpvar_14));
  highp vec2 tmpvar_15;
  tmpvar_15.x = sin(_Wave4.w);
  tmpvar_15.y = cos(_Wave4.w);
  tmpvar_7.zw = (((tmpvar_12 + _NormalMap_ST.zw) * _Wave4.y) + ((_Time.y * _Wave4.x) * tmpvar_15));
  highp vec3 tmpvar_16;
  tmpvar_16 = (_WorldSpaceCameraPos - vertex_2.xyz);
  highp vec4 tmpvar_17;
  tmpvar_17 = (_Object2World * _glesVertex);
  tmpvar_5.zw = ((tmpvar_17.xz * _MaskMap_ST.xy) + _MaskMap_ST.zw);
  highp mat3 tmpvar_18;
  tmpvar_18[0] = _ProjMatrix[0].xyz;
  tmpvar_18[1] = _ProjMatrix[1].xyz;
  tmpvar_18[2] = _ProjMatrix[2].xyz;
  tmpvar_8 = (tmpvar_18 * tmpvar_16);
  tmpvar_8.xy = (tmpvar_8.xy / tmpvar_8.z);
  tmpvar_8.xy = (((tmpvar_8.xy + 
    (_Speed.xy * _Time.xx)
  ) * _ReflectionTex_ST.xy) + _ReflectionTex_ST.zw);
  tmpvar_9 = (unity_World2Shadow[0] * tmpvar_17);
  gl_Position = tmpvar_3;
  xlv_COLOR = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = normalize(tmpvar_16.zxy);
  xlv_TEXCOORD4 = tmpvar_8;
  xlv_TEXCOORD5 = vertex_2.xyz;
  xlv_TEXCOORD6 = tmpvar_9;
  xlv_TEXCOORD7 = ((tmpvar_3.z * unity_FogParams.z) + unity_FogParams.w);
}














//////////////////f

#version 100


precision highp float;
uniform highp vec3 _WorldSpaceCameraPos;
uniform mediump vec4 _LightShadowData;
uniform lowp vec4 unity_FogColor;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _NormalMap;
uniform highp vec4 _Wave1;
uniform highp vec4 _Wave2;
uniform highp vec4 _Wave3;
uniform highp vec4 _Wave4;
uniform highp float _SparklingSpecularWidth;
uniform highp float _SparklingSpecularContrast;
uniform highp float _SparklingSpecularPower;
uniform highp float _SparklingSpecularScale;
uniform highp vec4 _SunColor;
uniform highp float _SunPower;
uniform sampler2D _ReflectionTex;
varying highp vec4 xlv_COLOR;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD5;
varying mediump vec4 xlv_TEXCOORD6;
varying highp float xlv_TEXCOORD7;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.xyz = xlv_COLOR.xyz;
  highp vec4 retColor_2;
  highp float bright_3;
  mediump vec3 h_4;
  highp vec3 color_5;
  highp vec4 normal_TS4_6;
  highp vec4 normal_TS3_7;
  highp vec4 normal_TS2_8;
  highp vec4 normal_TS1_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = ((texture2D (_NormalMap, xlv_TEXCOORD1.xy) * 2.0) - 1.0);
  normal_TS1_9 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = ((texture2D (_NormalMap, xlv_TEXCOORD1.zw) * 2.0) - 1.0);
  normal_TS2_8 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = ((texture2D (_NormalMap, xlv_TEXCOORD2.xy) * 2.0) - 1.0);
  normal_TS3_7 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = ((texture2D (_NormalMap, xlv_TEXCOORD2.zw) * 2.0) - 1.0);
  normal_TS4_6 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = normalize(((
    ((normal_TS1_9 * _Wave1.z) + (normal_TS2_8 * _Wave2.z))
   + 
    (normal_TS3_7 * _Wave3.z)
  ) + (normal_TS4_6 * _Wave4.z)));
  highp float tmpvar_15;
  tmpvar_15 = normalize((xlv_TEXCOORD5 - _WorldSpaceCameraPos)).z;
  highp vec3 tmpvar_16;
  tmpvar_16.x = _SparklingSpecularWidth;
  tmpvar_16.y = _SparklingSpecularWidth;
  tmpvar_16.z = _SparklingSpecularContrast;
  highp float tmpvar_17;
  tmpvar_17 = pow (clamp (dot (tmpvar_14.xyz, tmpvar_16), 0.0, 1.0), _SparklingSpecularPower);
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD4.xy + ((tmpvar_14.xz * tmpvar_14.y) * 0.25));
  tmpvar_18 = texture2D (_ReflectionTex, P_19);
  color_5 = (xlv_COLOR.xyz + ((tmpvar_18.xyz * xlv_TEXCOORD0.x) * pow (
    (tmpvar_15 + 0.15)
  , 8.0)));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((vec3(0.8374783, 0.1570272, 0.5234239) + xlv_TEXCOORD3));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, h_4.z);
  bright_3 = tmpvar_21;
  tmpvar_1.w = (xlv_COLOR.w + xlv_TEXCOORD0.y);
  highp float tmpvar_22;
  tmpvar_22 = min (1.0, pow (tmpvar_15, 12.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = ((clamp (
    ((vec3(pow (bright_3, _SunPower)) * (_SunColor.xyz + (
      (tmpvar_17 * _SunColor.w)
     * 8.0))) * vec3(pow ((tmpvar_15 + 0.1), 16.0)))
  , 0.0, 1.0) + (
    (color_5 * tmpvar_22)
   + 
    ((color_5 * (1.0 - tmpvar_22)) * dot (tmpvar_14.xyz, xlv_TEXCOORD3))
  )) + clamp ((tmpvar_17 * _SparklingSpecularScale), 0.0, 1.0));
  lowp float tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = max (float((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6).x > 
    (xlv_TEXCOORD6.z / xlv_TEXCOORD6.w)
  )), _LightShadowData.x);
  tmpvar_24 = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26.xyz = ((tmpvar_23 * 0.6) + ((tmpvar_23 * 0.4) * tmpvar_24));
  tmpvar_26.w = clamp (((2.625 * 
    (tmpvar_1.w * tmpvar_1.w)
  ) - xlv_TEXCOORD0.y), 0.0, 1.0);
  retColor_2.w = tmpvar_26.w;
  retColor_2.xyz = mix (unity_FogColor.xyz, tmpvar_26.xyz, vec3(clamp (xlv_TEXCOORD7, 0.0, 1.0)));
  gl_FragData[0] = retColor_2;
}








