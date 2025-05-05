namespace(:creds) do
  desc("Print an example credentials file")
  task(:example => :environment) do
    puts(Creds::EXAMPLE_CONFIG)
  end
end
