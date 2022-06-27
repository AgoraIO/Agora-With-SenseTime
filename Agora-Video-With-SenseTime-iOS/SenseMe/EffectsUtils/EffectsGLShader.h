#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

NS_ASSUME_NONNULL_BEGIN

@interface EffectsGLShader : NSObject

@property (nonatomic, assign) GLuint program;

- (instancetype)initWithVertexShader:(NSString *)vertexShader
                      fragmentShader:(NSString *)fragmentShader;

- (void)use;

- (void)addAttribute:(NSString *)attributeName;

- (GLuint)attributeIndex:(NSString *)attributeName;

- (GLuint)uniformIndex:(NSString *)uniformName;

- (void)setBoolWithName:(NSString *)name value:(GLboolean)value;

- (void)setIntWithName:(NSString *)name value:(int)value;

- (void)setFloatWithMame:(NSString *)name value:(float)value;

- (void)setVec2WithName:(NSString *)name value:(GLKVector2)value;

- (void)setVec3WithName:(NSString *)name value:(GLKVector3)value;

- (void)setvec4WithName:(NSString *)name value:(GLKVector4)value;

- (void)setMat2WithName:(NSString *)name value:(GLKMatrix2)value;

- (void)setMat3WithName:(NSString *)name value:(GLKMatrix3)value;

- (void)setMat4WithName:(NSString *)name value:(GLKMatrix4)value;

@end

NS_ASSUME_NONNULL_END
