//
//  SkinSmoothing.metal
//  MetalFilter
//
//  Created by Uran on 2019/7/4.
//  Copyright © 2019 Uran. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h> // includes CIKernelMetalLib.h

extern "C" {
    namespace coreimage {
        float4 myColor(sample_t s) {
            return s.grba;
        }
        
        // RGB 曲線調整
        float4 rgbToneCurveFilter(sampler image , sampler toneCurveTexture , float intensity){
            float4 textureColor = sample(image , samplerCoord(image));
            float4 toneCurveTextureExtent = samplerExtent(toneCurveTexture);
            
            
            float2 redCoord = toneCurveTexture.transform(float2(textureColor.r * 255.0 + 0.5 + toneCurveTextureExtent.x, toneCurveTextureExtent.y + 0.5));
            float2 greenCoord = toneCurveTexture.transform(float2(textureColor.g * 255.0 + 0.5 + toneCurveTextureExtent.x, toneCurveTextureExtent.y + 0.5));
            float2 blueCoord = toneCurveTexture.transform(float2(textureColor.b * 255.0 + 0.5 + toneCurveTextureExtent.x, toneCurveTextureExtent.y + 0.5));
            
            float redCurveValue = toneCurveTexture.sample(redCoord).r;
            float greenCurveValue = toneCurveTexture.sample(greenCoord).g;
            float blueCurveValue = toneCurveTexture.sample(blueCoord).b;
            return float4(mix(textureColor.rgb,float3(redCurveValue, greenCurveValue, blueCurveValue),intensity),textureColor.a);
        }
        // 對影像加入 平滑化的 遮罩
        float4 skinSmoothingMaskBoost(sample_t image) {
            float hardLightColor = image.b;
            for (int i = 0 ; i < 3 ; ++i){
                if (hardLightColor < 0.5){
                    hardLightColor = hardLightColor * hardLightColor * 2.0;
                }else{
                    hardLightColor = 1.0 - (1.0 - hardLightColor) * (1.0 - hardLightColor) * 2;
                }
            }
            const float k = 255.0 / (164.0 - 75.0);
            hardLightColor = (hardLightColor - 75.0 / 255.0) * k;
            return float4(float3(hardLightColor) , image.a);
        }
        // 藍綠 圖層混合覆蓋
        float4 greenBlueChannelOverlayBlend(sample_t image){
            float4 base = float4(image.g, image.g , image.g , 1.0);
            float4 overlay = float4(image.b , image.b , image.b , 1.0);
            float ba = 2.0 * overlay.b * base.b + overlay.b * (1.0 - base.a) + base.b * (1.0 - overlay.a);
            return float4(ba , ba , ba , image.a);
        }
        // 高反差保留
        float4 highPass(sample_t image , sample_t blurredImage){
            return float4(float3(image.rgb - blurredImage .rgb + float3(0.5 , 0.5 , 0.5)) , image.a);
        }
    }
}


