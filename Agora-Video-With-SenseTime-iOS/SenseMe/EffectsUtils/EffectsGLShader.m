#import "EffectsGLShader.h"

typedef NS_ENUM(NSUInteger, EffectsGLShaderType)
{
    EffectsGLShaderVertex,
    EffectsGLShaderTypeFragment,
    EffectsGLShaderTypeProgram,
};

@interface EffectsGLShader ()
@property (nonatomic, strong) NSMutableArray *attributes;
@property (nonatomic, copy) NSString *vertexShader;
@property (nonatomic, copy) NSString *fragmentShader;
@end

@implementation EffectsGLShader

- (instancetype)initWithVertexShader:(NSString *)vertexShader fragmentShader:(NSString *)fragmentShader
{
    if (!vertexShader || !fragmentShader) {
        return nil;
    }
    self = [super init];
    self.attributes = [NSMutableArray array];
    [self compileVertexShader:vertexShader fragmentShader:fragmentShader];
    return self;
}

- (void)compileVertexShader:(NSString *)vertexShader fragmentShader:(NSString *)fragmentShader
{
    self.vertexShader = vertexShader;
    self.fragmentShader = fragmentShader;
    
    //vertexShader
    GLuint verShader = glCreateShader(GL_VERTEX_SHADER);
    const char *vertexCode = vertexShader.UTF8String;
    glShaderSource(verShader, 1, &vertexCode, NULL);
    glCompileShader(verShader);
    [self checkCompileErrors:verShader type:EffectsGLShaderVertex];
    
    //fragmentShader
    GLuint fragShader = glCreateShader(GL_FRAGMENT_SHADER);
    const char *fragmentCode = fragmentShader.UTF8String;
    glShaderSource(fragShader, 1, &fragmentCode, NULL);
    glCompileShader(fragShader);
    [self checkCompileErrors:fragShader type:EffectsGLShaderTypeFragment];
    
    //program
    _program = glCreateProgram();
    glAttachShader(_program, verShader);
    glAttachShader(_program, fragShader);
    glLinkProgram(_program);
    [self checkCompileErrors:_program type:EffectsGLShaderTypeProgram];
    
    glDeleteProgram(verShader);
    glDeleteShader(fragShader);
}
- (void)checkCompileErrors:(GLuint)shader type:(EffectsGLShaderType)type
{
    GLint success;
    GLchar infoLog[1024];
    if (EffectsGLShaderTypeProgram != type) {
        glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
        if (!success) {
            glGetShaderInfoLog(shader, 1024, NULL, infoLog);
            printf("ERROR: SHADER_COMPILATION_ERROR OF TYPE %d, infoLog %s \n",  type, infoLog);
        }
    }
    else
    {
        glGetProgramiv(shader, GL_LINK_STATUS, &success);
        if (!success) {
            glGetProgramInfoLog(shader, 1024, NULL, infoLog);
            printf("ERROR: PROGRAM_LINKING_ERROR OF TYPE %d, infoLog %s \n", type, infoLog);
        }
    }
}

- (void)use
{
    if (_program) {
        glUseProgram(_program);
    }
}

- (void)addAttribute:(NSString *)attributeName
{
    if (![self.attributes containsObject:attributeName]) {
        [self.attributes addObject:attributeName];
        glBindAttribLocation(_program, (GLuint)[self.attributes indexOfObject:attributeName], [attributeName UTF8String]);
    }
}

- (GLuint)attributeIndex:(NSString *)attributeName
{
    return (GLuint)[self.attributes indexOfObject:attributeName];
}

- (GLuint)uniformIndex:(NSString *)uniformName
{
    return glGetUniformLocation(_program, uniformName.UTF8String);
}

- (void)setBoolWithName:(NSString *)name value:(GLboolean)value
{
    glUniform1i(glGetUniformLocation(_program, name.UTF8String), value);
}

- (void)setIntWithName:(NSString *)name value:(int)value
{
    glUniform1i(glGetUniformLocation(_program, name.UTF8String), value);
}

- (void)setFloatWithMame:(NSString *)name value:(float)value
{
    glUniform1f(glGetUniformLocation(_program, name.UTF8String), value);
}

- (void)setVec2WithName:(NSString *)name value:(GLKVector2)value
{
    glUniform2f(glGetUniformLocation(_program, name.UTF8String), value.x, value.y);
}

- (void)setVec3WithName:(NSString *)name value:(GLKVector3)value
{
    glUniform3f(glGetUniformLocation(_program, name.UTF8String), value.x, value.y, value.z);
}

- (void)setvec4WithName:(NSString *)name value:(GLKVector4)value
{
    glUniform4f(glGetUniformLocation(_program, name.UTF8String), value.x, value.y, value.z, value.w);
}

- (void)setMat2WithName:(NSString *)name value:(GLKMatrix2)value
{
    glUniformMatrix2fv(glGetUniformLocation(_program, name.UTF8String), 1, GL_FALSE, value.m);
}

- (void)setMat3WithName:(NSString *)name value:(GLKMatrix3)value
{
    glUniformMatrix3fv(glGetUniformLocation(_program, name.UTF8String), 1, GL_FALSE, value.m);
}

- (void)setMat4WithName:(NSString *)name value:(GLKMatrix4)value
{
    glUniformMatrix4fv(glGetUniformLocation(_program, name.UTF8String), 1, GL_FALSE, value.m);
}

- (void)dealloc
{
    if (_program) {
        glDeleteProgram(_program);
    }
}

@end
