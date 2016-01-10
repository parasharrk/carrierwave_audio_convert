class ConversionWorker
  include Sidekiq::Worker

  TO_FORMATS = ['mp3', 'ogg', 'wav']

  FFMPEG_CONVERT_OPTIONS = {
                              "mp3" => "-acodec libmp3lame",
                              "ogg" => "-acodec libvorbis",
                              "wav" => ""
                            }

  def perform(user_id)
    user = User.find user_id
    path = "#{Rails.root}/public#{user.audio_url}"
    
    file_ext = File.extname(path).downcase[1..-1]
    to_formats = ConversionWorker::TO_FORMATS.clone
    to_formats.delete(file_ext)
    to_formats.map do |format|
      new_file_path = path.gsub(/#{file_ext}$/, format)
      cmd = convert_command_for(path, new_file_path, format)
      yup = %x[#{cmd}]
    end
  end

  def convert_command_for source_path, target_path, format
    convert_options = ConversionWorker::FFMPEG_CONVERT_OPTIONS[format]
    "ffmpeg -i #{source_path} #{convert_options} #{target_path}"
  end
end