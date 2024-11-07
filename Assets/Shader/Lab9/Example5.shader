Shader "Unlit/TextureDotTexture"
{
    Properties
    {
        _MainTex1 ("Texture", 2D) = "white" {} 
        _MainTex2 ("Texture", 2D) = "white" {} 

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

            sampler2D _MainTex1;
            sampler2D _MainTex2;

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
                fixed4 texColor1 = tex2D(_MainTex1, i.uv);
                fixed4 texColor2 = tex2D(_MainTex2, i.uv);
                fixed4 finalText = texColor1 * texColor2;
                
                return finalText;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
