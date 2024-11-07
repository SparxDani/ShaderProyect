Shader "Custom/LambertAmbient" {
    Properties {
        _Color ("Color", Color) = (1, 1, 1, 1)
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct v2f {
                float4 pos : SV_POSITION;
                float3 normalDir : TEXCOORD0;
            };

            float4 _Color;

            v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normalDir = normalize(mul((float3x3) UNITY_MATRIX_IT_MV, v.normal));
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float ambient = 0.2;
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float lambert = max(0, dot(i.normalDir, lightDir));
                return _Color * (lambert + ambient);
            }
            ENDCG
        }
    }
}
