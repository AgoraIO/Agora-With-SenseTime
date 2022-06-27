#import <Foundation/Foundation.h>
#import <CoreMedia/CMFormatDescription.h>
#import <CoreMedia/CMSampleBuffer.h>

@protocol EFMovieRecorderDelegate;

@interface EFMovieRecorder : NSObject

- (instancetype)initWithURL:(NSURL *)URL delegate:(id<EFMovieRecorderDelegate>)delegate callbackQueue:(dispatch_queue_t)queue;

- (void)addVideoTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription transform:(CGAffineTransform)transform settings:(NSDictionary *)videoSettings;

- (void)addAudioTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)audioSettings;

- (void)prepareToRecord;

- (void)appendVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)appendVideoPixelBuffer:(CVPixelBufferRef)pixelBuffer withPresentationTime:(CMTime)presentationTime;

- (void)appendAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)finishRecording;

@end

@protocol EFMovieRecorderDelegate <NSObject>

@required
- (void)movieRecorderDidFinishPreparing:(EFMovieRecorder *)recorder;

- (void)movieRecorder:(EFMovieRecorder *)recorder didFailWithError:(NSError *)error;

- (void)movieRecorderDidFinishRecording:(EFMovieRecorder *)recorder;

@end
