# frigate

module runs frigate as a podman container, configuration assumes using modern (= or > 10th gen) intel cpu with iGPU
in addition config looks for a google coral tpu running under codeproject.ai for image processing / detections

at 30fps detect, system sees around 1% cpu core usage per camera feed, gpu sees around 15 - 25% busy while processing 2 x 2560x1920