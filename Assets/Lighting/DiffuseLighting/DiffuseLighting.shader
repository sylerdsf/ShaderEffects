﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Andy/DiffuseLighting"
{
	Properties
	{
		_Color("Diffuse Mat Color", Color) = (1,1,1,1)
	}
		SubShader
		{
			Tags
			{
				"RenderType"	= "Opaque"
				"LightMode"		= "ForwardBase"
			}
			LOD 100

			Pass
			{
				CGPROGRAM
				#pragma vertex		vert
				#pragma fragment	frag
				// make fog work
				#pragma multi_compile_fog

				#include "UnityCG.cginc"

				uniform float4 _LightColor0;
				uniform float4 _Color;
			

				struct vertexInput 
				{
					float4 vertex	:POSITION;
					float3 normal	:NORMAL;
				};

				struct vertexOutput 
				{
					float4 vertex	:SV_POSITION;
					float4 col		:COLOR;
				};


				vertexOutput vert (vertexInput input)
				{
					vertexOutput	output;
					float4x4		modelMatrix			= unity_ObjectToWorld;
					float4x4		modelMatrixInverse	= unity_WorldToObject;

					float3 normalDirection				= normalize(mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);
					float3 lightDirection				= normalize(_WorldSpaceLightPos0.xyz);


					float3 ambientLighting				= UNITY_LIGHTMODEL_AMBIENT * _Color.rgb;
					float3 diffuseReflection			= _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));

					output.col							= float4(diffuseReflection + ambientLighting, 1.0);
					output.vertex						= UnityObjectToClipPos(input.vertex);

					return output;
				}
			
				fixed4 frag (vertexOutput i) : COLOR
				{
					return i.col;
				}
				ENDCG
			}
		}
}
