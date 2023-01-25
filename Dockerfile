# Generated by Neurodocker and Reproenv.

FROM neurodebian:stretch-non-free
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
           && apt-get install -y --quiet \
                  g++ \
                  gcc \
                  octave \
           && rm -rf /var/lib/apt/lists/*
ENV FORCE_SPMMCR="1" \
    SPM_HTML_BROWSER="0" \
    SPMMCRCMD="/opt/spm12-r7771/run_spm12.sh /opt/matlab-compiler-runtime-2010a/v713 script" \
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu:/opt/matlab-compiler-runtime-2010a/v713/runtime/glnxa64:/opt/matlab-compiler-runtime-2010a/v713/bin/glnxa64:/opt/matlab-compiler-runtime-2010a/v713/sys/os/glnxa64:/opt/matlab-compiler-runtime-2010a/v713/extern/bin/glnxa64" \
    MATLABCMD="/opt/matlab-compiler-runtime-2010a/v713/toolbox/matlab"
RUN export TMPDIR="$(mktemp -d)" \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           ca-certificates \
           curl \
           libncurses5 \
           libxext6 \
           libxmu6 \
           libxpm-dev \
           libxt6 \
           multiarch-support \
           unzip \
    && rm -rf /var/lib/apt/lists/* \
    && _reproenv_tmppath="$(mktemp -t tmp.XXXXXXXXXX.deb)" \
    && curl -fsSL --retry 5 -o "${_reproenv_tmppath}" http://mirrors.kernel.org/debian/pool/main/libx/libxp/libxp6_1.0.2-2_amd64.deb \
    && apt-get install --yes -q "${_reproenv_tmppath}" \
    && rm "${_reproenv_tmppath}" \
    && apt-get update -qq \
    && apt-get install --yes --quiet --fix-missing \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Downloading MATLAB Compiler Runtime ..." \
    && curl -fL -o "$TMPDIR/MCRInstaller.bin" https://dl.dropbox.com/s/zz6me0c3v4yq5fd/MCR_R2010a_glnxa64_installer.bin \
    && chmod +x "$TMPDIR/MCRInstaller.bin" \
    && "$TMPDIR/MCRInstaller.bin" -silent -P installLocation="/opt/matlab-compiler-runtime-2010a" \
    && rm -rf "$TMPDIR" \
    && unset TMPDIR \
    # Install spm12
    && echo "Downloading standalone SPM12 ..." \
    && curl -fL -o /tmp/spm12.zip https://www.fil.ion.ucl.ac.uk/spm/download/restricted/utopia/previous/spm12_r7771_R2010a.zip \
    && unzip -q /tmp/spm12.zip -d /tmp \
    && mkdir -p /opt/spm12-r7771 \
    && mv /tmp/spm12/* /opt/spm12-r7771/ \
    && chmod -R 777 /opt/spm12-r7771 \
    && rm -rf /tmp/spm* \
    # Test
    && /opt/spm12-r7771/run_spm12.sh /opt/matlab-compiler-runtime-2010a/v713 quit
ENV OS="Linux" \
    PATH="/opt/freesurfer-7.1.1/bin:/opt/freesurfer-7.1.1/fsfast/bin:/opt/freesurfer-7.1.1/tktools:/opt/freesurfer-7.1.1/mni/bin:$PATH" \
    FREESURFER_HOME="/opt/freesurfer-7.1.1" \
    FREESURFER="/opt/freesurfer-7.1.1" \
    SUBJECTS_DIR="/opt/freesurfer-7.1.1/subjects" \
    LOCAL_DIR="/opt/freesurfer-7.1.1/local" \
    FSFAST_HOME="/opt/freesurfer-7.1.1/fsfast" \
    FMRI_ANALYSIS_DIR="/opt/freesurfer-7.1.1/fsfast" \
    FUNCTIONALS_DIR="/opt/freesurfer-7.1.1/sessions" \
    FS_OVERRIDE="0" \
    FIX_VERTEX_AREA="" \
    FSF_OUTPUT_FORMAT="nii.gz# mni env requirements" \
    MINC_BIN_DIR="/opt/freesurfer-7.1.1/mni/bin" \
    MINC_LIB_DIR="/opt/freesurfer-7.1.1/mni/lib" \
    MNI_DIR="/opt/freesurfer-7.1.1/mni" \
    MNI_DATAPATH="/opt/freesurfer-7.1.1/mni/data" \
    MNI_PERL5LIB="/opt/freesurfer-7.1.1/mni/share/perl5" \
    PERL5LIB="/opt/freesurfer-7.1.1/mni/share/perl5"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           ca-certificates \
           curl \
           libgomp1 \
           libxmu6 \
           libxt6 \
           perl \
           tcsh \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Downloading FreeSurfer ..." \
    && mkdir -p /opt/freesurfer-7.1.1 \
    && curl -fL https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.1.1/freesurfer-linux-centos6_x86_64-7.1.1.tar.gz \
    | tar -xz -C /opt/freesurfer-7.1.1 --owner root --group root --no-same-owner --strip-components 1 \
         --exclude='average/mult-comp-cor' \
         --exclude='lib/cuda' \
         --exclude='lib/qt' \
         --exclude='subjects/V1_average' \
         --exclude='subjects/bert' \
         --exclude='subjects/cvs_avg35' \
         --exclude='subjects/cvs_avg35_inMNI152' \
         --exclude='subjects/fsaverage3' \
         --exclude='subjects/fsaverage4' \
         --exclude='subjects/fsaverage5' \
         --exclude='subjects/fsaverage6' \
         --exclude='subjects/fsaverage_sym' \
         --exclude='trctrain'
COPY ["test_env.yml", \
      "/tmp/"]
ENV CONDA_DIR="/opt/miniconda-latest" \
    PATH="/opt/miniconda-latest/bin:$PATH"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bzip2 \
           ca-certificates \
           curl \
    && rm -rf /var/lib/apt/lists/* \
    # Install dependencies.
    && export PATH="/opt/miniconda-latest/bin:$PATH" \
    && echo "Downloading Miniconda installer ..." \
    && conda_installer="/tmp/miniconda.sh" \
    && curl -fsSL -o "$conda_installer" https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash "$conda_installer" -b -p /opt/miniconda-latest \
    && rm -f "$conda_installer" \
    && conda update -yq -nbase conda \
    # Prefer packages in conda-forge
    && conda config --system --prepend channels conda-forge \
    # Packages in lower-priority channels not considered if a package with the same
    # name exists in a higher priority channel. Can dramatically speed up installations.
    # Conda recommends this as a default
    # https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-channels.html
    && conda config --set channel_priority strict \
    && conda config --system --set auto_update_conda false \
    && conda config --system --set show_channel_urls true \
    # Enable `conda activate`
    && conda init bash \
    && conda env create  --name csp --file /tmp/test_env.yml \
    # Clean up
    && sync && conda clean --all --yes && sync \
    && rm -rf ~/.cache/pip/*
RUN test "$(getent passwd csp)" \
    || useradd --no-user-group --create-home --shell /bin/bash csp
USER csp
RUN mkdir /home/csp/data && chmod 777 /home/csp/data && chmod a+s /home/csp/data
RUN mkdir /home/csp/output && chmod 777 /home/csp/output && chmod a+s /home/csp/output
RUN mkdir /home/csp/code && chmod 777 /home/csp/code && chmod a+s /home/csp/code
RUN mkdir /home/csp/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > home/csp/.jupyter/jupyter_notebook_config.py
WORKDIR /home/csp/code

# Save specification to JSON.
USER root
RUN printf '{ \
  "pkg_manager": "apt", \
  "existing_users": [ \
    "root" \
  ], \
  "instructions": [ \
    { \
      "name": "from_", \
      "kwds": { \
        "base_image": "neurodebian:stretch-non-free" \
      } \
    }, \
    { \
      "name": "arg", \
      "kwds": { \
        "key": "DEBIAN_FRONTEND", \
        "value": "noninteractive" \
      } \
    }, \
    { \
      "name": "install", \
      "kwds": { \
        "pkgs": [ \
          "gcc", \
          "g++", \
          "octave" \
        ], \
        "opts": "--quiet" \
      } \
    }, \
    { \
      "name": "run", \
      "kwds": { \
        "command": "apt-get update -qq \\\\\\n    && apt-get install -y --quiet \\\\\\n           g++ \\\\\\n           gcc \\\\\\n           octave \\\\\\n    && rm -rf /var/lib/apt/lists/*" \
      } \
    }, \
    { \
      "name": "env", \
      "kwds": { \
        "FORCE_SPMMCR": "1", \
        "SPM_HTML_BROWSER": "0", \
        "SPMMCRCMD": "/opt/spm12-r7771/run_spm12.sh /opt/matlab-compiler-runtime-2010a/v713 script", \
        "LD_LIBRARY_PATH": "$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu:/opt/matlab-compiler-runtime-2010a/v713/runtime/glnxa64:/opt/matlab-compiler-runtime-2010a/v713/bin/glnxa64:/opt/matlab-compiler-runtime-2010a/v713/sys/os/glnxa64:/opt/matlab-compiler-runtime-2010a/v713/extern/bin/glnxa64", \
        "MATLABCMD": "/opt/matlab-compiler-runtime-2010a/v713/toolbox/matlab" \
      } \
    }, \
    { \
      "name": "run", \
      "kwds": { \
        "command": "export TMPDIR=\\"$\(mktemp -d\)\\"\\napt-get update -qq\\napt-get install -y -q --no-install-recommends \\\\\\n    bc \\\\\\n    ca-certificates \\\\\\n    curl \\\\\\n    libncurses5 \\\\\\n    libxext6 \\\\\\n    libxmu6 \\\\\\n    libxpm-dev \\\\\\n    libxt6 \\\\\\n    multiarch-support \\\\\\n    unzip\\nrm -rf /var/lib/apt/lists/*\\n_reproenv_tmppath=\\"$\(mktemp -t tmp.XXXXXXXXXX.deb\)\\"\\ncurl -fsSL --retry 5 -o \\"${_reproenv_tmppath}\\" http://mirrors.kernel.org/debian/pool/main/libx/libxp/libxp6_1.0.2-2_amd64.deb\\napt-get install --yes -q \\"${_reproenv_tmppath}\\"\\nrm \\"${_reproenv_tmppath}\\"\\napt-get update -qq\\napt-get install --yes --quiet --fix-missing\\nrm -rf /var/lib/apt/lists/*\\necho \\"Downloading MATLAB Compiler Runtime ...\\"\\ncurl -fL -o \\"$TMPDIR/MCRInstaller.bin\\" https://dl.dropbox.com/s/zz6me0c3v4yq5fd/MCR_R2010a_glnxa64_installer.bin\\nchmod +x \\"$TMPDIR/MCRInstaller.bin\\"\\n\\"$TMPDIR/MCRInstaller.bin\\" -silent -P installLocation=\\"/opt/matlab-compiler-runtime-2010a\\"\\nrm -rf \\"$TMPDIR\\"\\nunset TMPDIR\\n# Install spm12\\necho \\"Downloading standalone SPM12 ...\\"\\ncurl -fL -o /tmp/spm12.zip https://www.fil.ion.ucl.ac.uk/spm/download/restricted/utopia/previous/spm12_r7771_R2010a.zip\\nunzip -q /tmp/spm12.zip -d /tmp\\nmkdir -p /opt/spm12-r7771\\nmv /tmp/spm12/* /opt/spm12-r7771/\\nchmod -R 777 /opt/spm12-r7771\\nrm -rf /tmp/spm*\\n# Test\\n/opt/spm12-r7771/run_spm12.sh /opt/matlab-compiler-runtime-2010a/v713 quit" \
      } \
    }, \
    { \
      "name": "env", \
      "kwds": { \
        "OS": "Linux", \
        "PATH": "/opt/freesurfer-7.1.1/bin:/opt/freesurfer-7.1.1/fsfast/bin:/opt/freesurfer-7.1.1/tktools:/opt/freesurfer-7.1.1/mni/bin:$PATH", \
        "FREESURFER_HOME": "/opt/freesurfer-7.1.1", \
        "FREESURFER": "/opt/freesurfer-7.1.1", \
        "SUBJECTS_DIR": "/opt/freesurfer-7.1.1/subjects", \
        "LOCAL_DIR": "/opt/freesurfer-7.1.1/local", \
        "FSFAST_HOME": "/opt/freesurfer-7.1.1/fsfast", \
        "FMRI_ANALYSIS_DIR": "/opt/freesurfer-7.1.1/fsfast", \
        "FUNCTIONALS_DIR": "/opt/freesurfer-7.1.1/sessions", \
        "FS_OVERRIDE": "0", \
        "FIX_VERTEX_AREA": "", \
        "FSF_OUTPUT_FORMAT": "nii.gz# mni env requirements", \
        "MINC_BIN_DIR": "/opt/freesurfer-7.1.1/mni/bin", \
        "MINC_LIB_DIR": "/opt/freesurfer-7.1.1/mni/lib", \
        "MNI_DIR": "/opt/freesurfer-7.1.1/mni", \
        "MNI_DATAPATH": "/opt/freesurfer-7.1.1/mni/data", \
        "MNI_PERL5LIB": "/opt/freesurfer-7.1.1/mni/share/perl5", \
        "PERL5LIB": "/opt/freesurfer-7.1.1/mni/share/perl5" \
      } \
    }, \
    { \
      "name": "run", \
      "kwds": { \
        "command": "apt-get update -qq\\napt-get install -y -q --no-install-recommends \\\\\\n    bc \\\\\\n    ca-certificates \\\\\\n    curl \\\\\\n    libgomp1 \\\\\\n    libxmu6 \\\\\\n    libxt6 \\\\\\n    perl \\\\\\n    tcsh\\nrm -rf /var/lib/apt/lists/*\\necho \\"Downloading FreeSurfer ...\\"\\nmkdir -p /opt/freesurfer-7.1.1\\ncurl -fL https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.1.1/freesurfer-linux-centos6_x86_64-7.1.1.tar.gz \\\\\\n| tar -xz -C /opt/freesurfer-7.1.1 --owner root --group root --no-same-owner --strip-components 1 \\\\\\n  --exclude='"'"'average/mult-comp-cor'"'"' \\\\\\n  --exclude='"'"'lib/cuda'"'"' \\\\\\n  --exclude='"'"'lib/qt'"'"' \\\\\\n  --exclude='"'"'subjects/V1_average'"'"' \\\\\\n  --exclude='"'"'subjects/bert'"'"' \\\\\\n  --exclude='"'"'subjects/cvs_avg35'"'"' \\\\\\n  --exclude='"'"'subjects/cvs_avg35_inMNI152'"'"' \\\\\\n  --exclude='"'"'subjects/fsaverage3'"'"' \\\\\\n  --exclude='"'"'subjects/fsaverage4'"'"' \\\\\\n  --exclude='"'"'subjects/fsaverage5'"'"' \\\\\\n  --exclude='"'"'subjects/fsaverage6'"'"' \\\\\\n  --exclude='"'"'subjects/fsaverage_sym'"'"' \\\\\\n  --exclude='"'"'trctrain'"'"'" \
      } \
    }, \
    { \
      "name": "copy", \
      "kwds": { \
        "source": [ \
          "test_env.yml", \
          "/tmp/" \
        ], \
        "destination": "/tmp/" \
      } \
    }, \
    { \
      "name": "env", \
      "kwds": { \
        "CONDA_DIR": "/opt/miniconda-latest", \
        "PATH": "/opt/miniconda-latest/bin:$PATH" \
      } \
    }, \
    { \
      "name": "run", \
      "kwds": { \
        "command": "apt-get update -qq\\napt-get install -y -q --no-install-recommends \\\\\\n    bzip2 \\\\\\n    ca-certificates \\\\\\n    curl\\nrm -rf /var/lib/apt/lists/*\\n# Install dependencies.\\nexport PATH=\\"/opt/miniconda-latest/bin:$PATH\\"\\necho \\"Downloading Miniconda installer ...\\"\\nconda_installer=\\"/tmp/miniconda.sh\\"\\ncurl -fsSL -o \\"$conda_installer\\" https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh\\nbash \\"$conda_installer\\" -b -p /opt/miniconda-latest\\nrm -f \\"$conda_installer\\"\\nconda update -yq -nbase conda\\n# Prefer packages in conda-forge\\nconda config --system --prepend channels conda-forge\\n# Packages in lower-priority channels not considered if a package with the same\\n# name exists in a higher priority channel. Can dramatically speed up installations.\\n# Conda recommends this as a default\\n# https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-channels.html\\nconda config --set channel_priority strict\\nconda config --system --set auto_update_conda false\\nconda config --system --set show_channel_urls true\\n# Enable `conda activate`\\nconda init bash\\nconda env create  --name csp --file /tmp/test_env.yml\\n# Clean up\\nsync && conda clean --all --yes && sync\\nrm -rf ~/.cache/pip/*" \
      } \
    }, \
    { \
      "name": "user", \
      "kwds": { \
        "user": "csp" \
      } \
    }, \
    { \
      "name": "run", \
      "kwds": { \
        "command": "mkdir /home/csp/data && chmod 777 /home/csp/data && chmod a+s /home/csp/data" \
      } \
    }, \
    { \
      "name": "run", \
      "kwds": { \
        "command": "mkdir /home/csp/output && chmod 777 /home/csp/output && chmod a+s /home/csp/output" \
      } \
    }, \
    { \
      "name": "run", \
      "kwds": { \
        "command": "mkdir /home/csp/code && chmod 777 /home/csp/code && chmod a+s /home/csp/code" \
      } \
    }, \
    { \
      "name": "run", \
      "kwds": { \
        "command": "mkdir /home/csp/.jupyter && echo c.NotebookApp.ip = \\\\\\"0.0.0.0\\\\\\" > home/csp/.jupyter/jupyter_notebook_config.py" \
      } \
    }, \
    { \
      "name": "workdir", \
      "kwds": { \
        "path": "/home/csp/code" \
      } \
    } \
  ] \
}' > /.reproenv.json
USER csp
# End saving to specification to JSON.
