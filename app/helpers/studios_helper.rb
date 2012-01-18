module StudiosHelper

  def copyright_for(studio)
    process_mustache_markdown_template(studio.copyright_notice, studio)
  end

end
