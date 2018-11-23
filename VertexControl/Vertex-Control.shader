// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Rolan/Vertex-Control" {
 
	Properties{
		_HeightTex ("高度图",2D) = "White"{}
		_R("R",range(0,5))=1
		_Height ("高度-默认为1",Range(-10,10) ) = 1
	}
 
	SubShader{
		pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "unitycg.cginc"
 
		float dis;
		float r;
 
		float _R;
		float _Height;

		sampler2D  _HeightTex;fixed4 _HeightTex_ST;


		struct VertexInput
		{
			float4 vertex : POSITION;
			float3 normal : Normal;
			float4 tangent: TANGENT;
			float2 texcoord0 : TEXCOORD0;			 			
		};
 
		struct VertexOutput {
			float4 pos:SV_POSITION;
			float2 uv0 : TEXCOORD0 ;
			float4 posWorld: TEXCOORD1;
			float3 normalDir: TEXCOORD2;
			float3 tangentDir: TEXCOORD3;
			float3 bitangentDir: TEXCOORD4;

			fixed4 color : COLOR;
			
		};
 
 
 
		VertexOutput vert(VertexInput v) {
			VertexOutput o;
			//x、y坐标
			//float2 xy = v.vertex.xz;
			
			//float2 
			//求到圆心的距离，即半径
			//float d = sqrt((xy.x - 0)*(xy.x - 0) + (xy.y-0)*(xy.y - 0));
			//也可以使用下面的计算摸长的方式
		//	float d = _R - length(xy);
			//d小于0则不抬升，否则抬升
		//	d = d < 0 ? 0 : d;
			//float height=1;
			o.uv0 = v.texcoord0 ;
			o.normalDir = UnityObjectToWorldNormal(v.normal);
			//float4 uppos = float4(v.vertex.x,height*d,v.vertex.z,v.vertex.w);
		    float3 dHeight = tex2Dlod(_HeightTex,float4(o.uv0 * _HeightTex_ST.xy,0,0));
		    
		    v.vertex.xyz = v.vertex.xyz + v.normal *  dHeight.r * _Height;

			o.pos = UnityObjectToClipPos(  v.vertex);
			
		
			//x的坐标值
			//float x = o.pos.x / o.pos.w;
 
			//if (x >dis && x<dis+r)											//在屏幕最左边
		//		o.color = fixed4(1, 0, 0, 1);							//显示为红色
		//	else
		//		o.color = fixed4(x/2+0.5,x/2+0.5,x/2+0.5,1);			//灰度
 
			return o;


		}
 
 
		fixed4 frag(VertexOutput i) :COLOR{
			float3 diffuse = tex2D(_HeightTex,TRANSFORM_TEX(i.uv0,_HeightTex));

			return fixed4 (diffuse,1);
		}
			ENDCG
	}
	}
 
}

