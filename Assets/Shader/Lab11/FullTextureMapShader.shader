Shader "Custom/FullTextureMapShader"
{
    Properties
    {
        _MainTex("Base Texture", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {}
        _SpecularMap("Specular Map", 2D) = "black" {}
        _HeightMap("Height Map", 2D) = "black" {}
        _AOMap("Ambient Occlusion Map", 2D) = "white" {}
        _EmissiveMap("Emissive Map", 2D) = "black" {}
        _EmissiveColor("Emissive Color", Color) = (1, 1, 1, 1)
        _HeightScale("Height Scale", Float) = 0.05
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 300

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        #include "UnityCG.cginc"

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float2 uv_SpecularMap;
            float2 uv_HeightMap;
            float2 uv_AOMap;
            float2 uv_EmissiveMap;
        };

        sampler2D _MainTex;
        sampler2D _NormalMap;
        sampler2D _SpecularMap;
        sampler2D _HeightMap;
        sampler2D _AOMap;
        sampler2D _EmissiveMap;
        float4 _EmissiveColor;
        float _HeightScale;

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            // Textura base
            fixed4 baseColor = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = baseColor.rgb;

            // Normal Map
            fixed4 normalTex = tex2D(_NormalMap, IN.uv_NormalMap);
            o.Normal = UnpackNormal(normalTex);

            // Specular Map
            fixed4 specTex = tex2D(_SpecularMap, IN.uv_SpecularMap);
            o.Metallic = specTex.r; // Uso del canal rojo para la reflectancia metálica
            o.Smoothness = specTex.g; // Uso del canal verde para suavidad

            // Ambient Occlusion
            fixed ao = tex2D(_AOMap, IN.uv_AOMap).r; // Uso del canal rojo para AO
            o.Occlusion = ao;

            // Emission
            fixed4 emissiveTex = tex2D(_EmissiveMap, IN.uv_EmissiveMap);
            o.Emission = emissiveTex.rgb * _EmissiveColor.rgb;

            // Height Map para desplazamiento
            fixed height = tex2D(_HeightMap, IN.uv_HeightMap).r;
            height = height * _HeightScale;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
