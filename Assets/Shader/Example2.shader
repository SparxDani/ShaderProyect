Shader "Unlit/ColorInterpolation"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1, 0, 0, 1) // Primer color
        _ColorB ("Color B", Color) = (0, 0, 1, 1) // Segundo color
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

            #include "UnityCG.cginc"

            // Definir las variables para los colores
            fixed4 _ColorA;
            fixed4 _ColorB;

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = lerp(_ColorA, _ColorB, i.uv.y);
                return color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
